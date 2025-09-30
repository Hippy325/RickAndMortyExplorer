//
//  Utils+Register.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 27.09.2025.
//

import Foundation
import DITranquillity

public func registerUtilsServices(container: DIContainer) {
    container.register(UIAlersService.init)
        .as(IUIAlersService.self)
        .lifetime(.objectGraph)
    
    container.register { URLSession.shared }
        .as(URLSession.self)
        .lifetime(.objectGraph)
    
    container.register { JSONDecoder.init() }
        .as(JSONDecoder.self)
        .lifetime(.objectGraph)
    
    container.register(HTTPClient.init)
        .as(IHTTPClient.self)
        .lifetime(.objectGraph)
    
    container.register(ImageLoaderPublisher.init)
        .as(IImageLoader.self)
        .lifetime(.objectGraph)
}
