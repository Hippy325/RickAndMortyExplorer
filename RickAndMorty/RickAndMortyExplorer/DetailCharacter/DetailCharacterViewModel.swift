//
//  DetailCharacterViewModel.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 29.09.2025.
//

import Combine
import Foundation

//@Observable
final class DetailCharacterViewModel: ObservableObject {

    @Published
    private(set) var state: DetailState = .loading
    private let index: Int
    private let characterService: ICharacterService
    private var cancellables = Set<AnyCancellable>()

    init(
        index: Int,
        characterService: ICharacterService
    ) {
        self.index = index
        self.characterService = characterService
    }
    
    func send(_ input: DetailEvent) {
        switch input {
        case .onAppear:
            loadCharacter()
        }
    }
    
    private func loadCharacter() {
        state = .loading
        characterService.loadCharacter(index)
            .receive(on: DispatchQueue.main)
            .map { DetailCharacter(character: $0) }
            .sink { completion in
                if case .failure = completion {
                    self.state = .error
                }
            } receiveValue: { character in
                self.state = .loaded(character)
            }
            .store(in: &cancellables)
    }
}
