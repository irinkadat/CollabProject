//
//  Species.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import Foundation

struct Cities: Decodable {
    let results: [ResultForCountries]
}

struct ResultForCountries: Decodable {
    let id: Int
}

struct Species: Decodable {
    let results: [ResultForSpecies]
}

struct ResultForSpecies: Decodable {
    let taxon: Taxon
}

struct Taxon: Decodable {
    let name: String
    let extinct: Bool
    let defaultPhoto: DefaultPhoto
    let atlasID: Int?
    let wikipediaURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name, extinct
        case defaultPhoto = "default_photo"
        case atlasID = "atlas_id"
        case wikipediaURL = "wikipedia_url"
    }
}

struct DefaultPhoto: Codable {
    let url: String
    let attribution: String
    let squareURL, mediumURL: String

    enum CodingKeys: String, CodingKey {
        case url, attribution
        case squareURL = "square_url"
        case mediumURL = "medium_url"
    }
}
