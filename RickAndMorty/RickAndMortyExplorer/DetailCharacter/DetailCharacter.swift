//
//  DetailCharacter.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 29.09.2025.
//

import Foundation

struct DetailCharacter: Hashable {
    let name: String
    let race: String
    let gender: String
    let status: String
    let location: String
    let countEpisode: String
    let imageUrl: URL?
    
    init(
        name: String,
        race: String,
        gender: String,
        status: String,
        location: String,
        countEpisode: String,
        imageUrl: URL?
    ) {
        self.name = name
        self.race = race
        self.gender = gender
        self.status = status
        self.location = location
        self.countEpisode = countEpisode
        self.imageUrl = imageUrl
    }
    
    init(character: Character) {
        self.name = character.name
        self.race = character.species
        self.gender = character.gender
        self.status = character.status
        self.location = character.location.name
        self.countEpisode = String(character.episode.count)
        self.imageUrl = character.image
    }
}
