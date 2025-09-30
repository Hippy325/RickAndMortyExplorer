//
//  CharactersDTO.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 25.09.2025.
//

import Foundation

struct Location: Decodable {
    var name: String
}

struct Character: Decodable {
    var index: Int
    var name: String
    var species: String
    var gender: String
    var status: String
    var location: Location
    var episode: [String]

    var image: URL?

    enum CodingKeys: String, CodingKey {
        case index = "id"
        case name
        case species
        case gender
        case status
        case location
        case episode
        case image
    }
}

struct CharacterResponse: Decodable {

    struct ListInfo: Decodable {
        var count: Int
        var pages: Int
        var next: URL?
    }

    var info: ListInfo
    var results: [Character]
}
