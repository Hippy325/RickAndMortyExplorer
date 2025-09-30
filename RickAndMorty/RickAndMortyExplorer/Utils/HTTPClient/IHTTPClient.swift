//
//  IHTTPClient.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 24.09.2025.
//

import Foundation
import Combine

protocol IHTTPClient {
    
    func loadData(
        _ str: String
    ) -> AnyPublisher<Data, HTTPError>

    func load<T: Decodable>(
       _ str: String,
        responseType: T.Type
    ) -> AnyPublisher<T, HTTPError>

    func loadData(
        _ url: URL
    ) -> AnyPublisher<Data, HTTPError>

    func load<T: Decodable>(
        _ url: URL,
        responseType: T.Type
    ) -> AnyPublisher<T, HTTPError>
}
