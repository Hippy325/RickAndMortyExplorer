//
//  HTTPClient.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 24.09.2025.
//

import Foundation
import Combine
import DITranquillity

final class HTTPClient: IHTTPClient {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let alertService: IUIAlersService
    
    init(
        session: URLSession,
        decoder: JSONDecoder,
        alertService: IUIAlersService
    ) {
        self.session = session
        self.decoder = decoder
        self.alertService = alertService
    }
    
    func loadData(
        _ url: URL
    ) -> AnyPublisher<Data, HTTPError> {
        let request = URLRequest(url: url)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                if let error = self.handelingStatusCode(response) {
                    throw error
                }
                return data
            }
            .mapError { error -> HTTPError in
                if let httpError = error as? HTTPError {
                    return httpError
                }
                return self.handelingError(error) ?? .networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func loadData(
        _ str: String
    ) -> AnyPublisher<Data, HTTPError> {
        guard let url = URL(string: str) else {
            print("Invalid URL: \(str)")
            return Fail(error: HTTPError.invalidURL).eraseToAnyPublisher()
        }
        
        return loadData(url)
    }
    
    func load<T>(
        _ url: URL,
        responseType type: T.Type
    ) -> AnyPublisher<T, HTTPError> where T : Decodable {
        let request = URLRequest(url: url)
        logRequest(request)
        
        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { [weak self] data, response in
                self?.logResponse(response, data: data, error: nil)
            }, receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.logResponse(nil, data: nil, error: error)
                }
            })
            .tryMap { data, response -> T in
                if let error = self.handelingStatusCode(response) {
                    throw error
                }
                do {
                    return try self.decoder.decode(T.self, from: data)
                } catch {
                    throw HTTPError.faildDecode(error)
                }
            }
            .mapError { error -> HTTPError in
                if let httpError = error as? HTTPError {
                    return httpError
                }
                return self.handelingError(error) ?? .networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func load<T>(
        _ str: String,
        responseType: T.Type
    ) -> AnyPublisher<T, HTTPError> where T : Decodable {
        guard let url = URL(string: str) else {
            print("Invalid URL: \(str)")
            return Fail(error: HTTPError.invalidURL).eraseToAnyPublisher()
        }
        
        return load(url, responseType: responseType)
    }
    
    private func handelingError(_ error: Error?) -> HTTPError? {
        if let error = error as NSError? {
            DispatchQueue.main.async { [weak self] in
                self?.alertService.show(message: "Ошибка соединения с интернетом")
            }
            switch error.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
                return .networkError(error)
            case NSURLErrorTimedOut:
                return .timedOut
            default:
                return .networkError(error)
            }
        }
        return nil
    }
    
    private func handelingStatusCode(_ response: URLResponse?) -> HTTPError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return nil
        case 404:
            return .notFound
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .invalidStatusCode(httpResponse.statusCode)
        }
    }
    
    private func logRequest(_ request: URLRequest) {
        print("=============================")
        print("URL: \(request.url?.absoluteString ?? "Unknown URL")")
        print("Method: \(request.httpMethod ?? "Unknown")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
    }
    
    private func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
        }
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseString)")
        } else {
            print("Response Body: None")
        }
        print("=============================")
    }
}
