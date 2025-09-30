//
//  ApplicationDependency.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 27.09.2025.
//

import DITranquillity
import Foundation

final class ApplicationDependency: DIFramework {
    static func load(container: DIContainer) {
        
        registerUtilsServices(container: container)
        
        container.register(CharacteService.init)
            .as(ICharacterService.self)
        
        container.register(CharacterListAssembly.init)
            .as(ICharacterListAssembly.self)
        
        container.register(DetailCharacterViewAssembly.init)
            .as(IDetailCharacterViewAssembly.self)
    }
}
