//
//  ImageLoader.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 25.09.2025.
//

import Foundation
import Combine
import UIKit


protocol IImageLoader {
    func loadImage(
        _ url: URL?
    ) -> AnyPublisher<UIImage?, ImageLoaderPublisher.ImageError>
}

final class ImageLoaderPublisher: IImageLoader {
    
    enum ImageError: Error {
        case cannotConvertDataToImage
        case invalidURL
        case httpError(HTTPError)
    }
    
    private let lock = NSLock()
    private var images = NSCache<NSString, UIImage>()
    private var cancellable = Set<AnyCancellable>()
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    private func set(image: UIImage, for url: URL) {
        lock.lock()
        images.setObject(image, forKey: url.absoluteString as NSString)
        lock.unlock()
    }
    
    private func get(for url: URL) -> UIImage? {
        lock.lock()
        let image = images.object(forKey: url.absoluteString as NSString)
        lock.unlock()
        return image
    }
    
    func loadImage(
        _ url: URL?
    ) -> AnyPublisher<UIImage?, ImageError> {
        guard let url = url else { return Fail(error: .invalidURL).eraseToAnyPublisher() }
        
        if let image = get(for: url) {
            return Just(image)
                .setFailureType(to: ImageError.self)
                .eraseToAnyPublisher()
        }
        
        return httpClient.loadData(url)
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else { throw ImageError.cannotConvertDataToImage }
                self.set(image: image, for: url)
                return image
            }
            .mapError({ error in
                if let httpError = error as? HTTPError {
                    return .httpError(httpError)
                }
                return ImageError.cannotConvertDataToImage
            })
            .eraseToAnyPublisher()
    }
}
