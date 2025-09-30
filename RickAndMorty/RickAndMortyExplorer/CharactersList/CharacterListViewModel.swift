//
//  CharacterListViewModel.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 26.09.2025.
//

import Foundation
import Combine

protocol ICharacterListViewModel {
    var models: [CharacterListItem] { get }
    func send(_ event: CharacterListViewModel.ListEvent)
    var statePublisher: Published<CharacterListViewModel.ListState>.Publisher { get }
}

final class CharacterListViewModel: ICharacterListViewModel {
    
    enum ListEvent {
        case onAppear
        case onSelectCharacter(Int)
        case setStatusFilter(Int)
        case setNameFilter(String?)
        case onApplyFilters
    }
    
    enum ListState {
        case initialLoading
        case loaded
    }
    
    private let characterService: ICharacterService
    private let imageLoader: IImageLoader
    private let router: ICharacterListRouter
    
    @Published private var state: ListState = .initialLoading
    private var store = Set<AnyCancellable>()
    private var page = 1
    private var filters: [String: String] = [:]
    
    var models: [CharacterListItem] = []
    var statePublisher: Published<ListState>.Publisher {
        $state
    }
    
    init(
        characterService: ICharacterService,
        imageLoader: IImageLoader,
        router: ICharacterListRouter
    ) {
        self.characterService = characterService
        self.imageLoader = imageLoader
        self.router = router
    }
    
    func send(_ event: ListEvent) {
        switch event {
        case .onAppear:
            loadingCharacters()
        case .onSelectCharacter(let index):
            switch models[index] {
            case .character(characterItem: let item):
                router.showCharacterDetail(with: item.id)
            case .loader:
                break
            }
        case .onApplyFilters:
            models = []
            page = 1
            loadingCharacters()
        case .setStatusFilter(let index):
            switch index {
            case 1:
                filters["status"] = "Alive"
            case 2:
                filters["status"] = "Dead"
            case 3:
                filters["status"] = "Unknown"
            default:
                filters.removeValue(forKey: "status")
            }
        case .setNameFilter(let name):
            if let name = name, !name.isEmpty {
                filters["name"] = name
            } else {
                filters.removeValue(forKey: "name")
            }
        }
    }
}

private extension CharacterListViewModel {
    func loadingCharacters() {
        if (models.isEmpty) {
            state = .initialLoading
        }
        characterService.loadCharacterPage(
            page: page,
            filters["name"],
            filters["status"]
        )
        .receive(on: DispatchQueue.main)
        .replaceError(with: ([], page))
        .sink { result in
            if self.models.count != 0 {
                self.models.removeLast()
            }
            result.0.forEach {
                self.models.append(.character(characterItem: self.transformCharacter(from: $0)))
            }
            
            if self.page < result.1 {
                self.page += 1
                self.models.append(.loader)
            }
            self.state = .loaded
        }
        .store(in: &store)
    }
    
    func transformCharacter(from character: Character) -> CharacterItem {
        CharacterItem(
            id: character.index,
            name: character.name,
            race: character.species,
            gender: character.gender,
            status: CharacterItem.Status.fromString(str: character.status)
        ) { imageSetter in
            imageSetter(
                self.imageLoader.loadImage(character.image)
                    .replaceError(with: nil)
                    .eraseToAnyPublisher()
            )
        }
    }
}
