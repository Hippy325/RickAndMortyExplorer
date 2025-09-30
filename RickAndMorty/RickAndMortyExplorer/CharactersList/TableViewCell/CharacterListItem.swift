//
//  CharacterListItem.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 26.09.2025.
//

import Foundation
import Combine
import UIKit

enum CharacterListItem: Hashable {
    case character(characterItem: CharacterItem)
    case loader
}

struct CharacterItem: Hashable {
    
    enum Status: String {
        case dead
        case alive
        case unowned
        
        static func fromString(str: String) -> Self {
            switch str {
            case "Dead":
                return .dead
            case "Alive":
                return .alive
            default:
                return .unowned
            }
        }
    }

    // MARK: - Properties

    let id: Int
    let name: String
    let race: String
    let gender: String
    let status: Status

    let image: (_ imageSetter: @escaping (AnyPublisher<UIImage?, Never>) -> Void) -> Void

    // MARK: - Hashable

    static func == (lhs: CharacterItem, rhs: CharacterItem) -> Bool {
        lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.race == rhs.race
            && lhs.gender == rhs.gender
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(race)
        hasher.combine(gender)
    }
}

