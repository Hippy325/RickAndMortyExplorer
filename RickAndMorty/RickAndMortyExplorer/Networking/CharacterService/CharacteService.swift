//
//  CharacterLoader.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 26.09.2025.
//

import Foundation
import Combine

final class CharacteService: ICharacterService {
    
    // MARK: - Properties
    
    private let httpClient: IHTTPClient
    
    // MARK: - Init
    
    init(httpClient: IHTTPClient) {
        self.httpClient = httpClient
    }
    
    // MARK: - Protocol implementation
    
    func loadCharacter(_ characterIndex: Int) -> AnyPublisher<Character, HTTPError> {
        httpClient.load(
            "https://rickandmortyapi.com/api/character/\(characterIndex)",
            responseType: Character.self
        )
    }
    
    func loadCharacterPage(
        page: Int,
        _ name: String?,
        _ status: String?
    ) -> AnyPublisher<([Character], Int), HTTPError> {
        var url = "https://rickandmortyapi.com/api/character/?page=\(page)"
        if let name = name {
            url += "&name=\(name)"
        }
        if let status = status {
            url += "&status=\(status)"
        }
        return httpClient.load(
            url,
            responseType: CharacterResponse.self
        )
        .map { ($0.results, $0.info.pages) }
        .eraseToAnyPublisher()
    }
}
