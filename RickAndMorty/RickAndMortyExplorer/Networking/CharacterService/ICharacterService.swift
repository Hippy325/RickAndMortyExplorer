//
//  ICharacterService.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 26.09.2025.
//

import Combine

protocol ICharacterService: AnyObject {
    func loadCharacter(_ characterIndex: Int) -> AnyPublisher<Character, HTTPError>
    func loadCharacterPage(
        page: Int,
        _ name: String?,
        _ status: String?
    ) -> AnyPublisher<([Character], Int), HTTPError>
}
