//
//  CharactersResponse.swift
//  RickMortyMarcosSuarez
//
//  Created by Marcos Suarez Ayala on 16/4/24.
//

import Foundation

struct CharacterListResponse: Codable {
    let info: Info
    let characters: [CharacterInfo]
    
    enum CodingKeys: String, CodingKey {
        case info
        case characters = "results"
    }
}

struct Info: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}

struct CharacterInfo: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Result: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
    case genderless = "Genderless"
}

struct Location: Codable, Hashable {
    let name: String
    let url: String
}

enum Species: String, Codable {
    case alien = "Alien"
    case human = "Human"
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
