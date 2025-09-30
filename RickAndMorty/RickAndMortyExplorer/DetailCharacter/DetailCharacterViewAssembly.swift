//
//  DetailCharacterViewAsembly.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 29.09.2025.
//

import UIKit
import SwiftUI

protocol IDetailCharacterViewAssembly {
    func assembly(_ index: Int) -> UIViewController
}

final class DetailCharacterViewAssembly: IDetailCharacterViewAssembly {
    
    private let characterService: ICharacterService
    
    init(characterService: ICharacterService) {
        self.characterService = characterService
    }
    
    func assembly(_ index: Int) -> UIViewController {
        let viewModel = DetailCharacterViewModel(
            index: index,
            characterService: characterService
        )
        let detailView = DetailCharacterView(viewModel: viewModel)
        return UIHostingController(rootView: detailView)
    }
}
