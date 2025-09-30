//
//  CharacterListAssembly.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 27.09.2025.
//

import UIKit

protocol ICharacterListAssembly: AnyObject {
    func assembly() -> UIViewController
}

final class CharacterListAssembly: ICharacterListAssembly {
    private let characterService: ICharacterService
    private let imageLoader: IImageLoader
    private let detailCharacterAssembly: IDetailCharacterViewAssembly
    
    init(
        characterService: ICharacterService,
        imageLoader: IImageLoader,
        detailCharacterAssembly: IDetailCharacterViewAssembly
    ) {
        self.characterService = characterService
        self.imageLoader = imageLoader
        self.detailCharacterAssembly = detailCharacterAssembly
    }
    
    func assembly() -> UIViewController {
        let router = CharacterListRouter(
            detailCharacterAssembly: detailCharacterAssembly
        )
        let viewModel = CharacterListViewModel(
            characterService: characterService,
            imageLoader: imageLoader,
            router: router
        )
        let viewController = CharacterListViewController(
            viewModel: viewModel
        )
        router.viewController = viewController
        return viewController
    }
}
