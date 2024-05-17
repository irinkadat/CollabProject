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
    let isActive: Bool
    let name: String
    let ancestry: String
    let extinct: Bool
    let defaultPhoto: DefaultPhoto
    let atlasID: Int?
    let wikipediaURL: String?
}

struct DefaultPhoto: Decodable {
    let url: String
    let squareURL, mediumURL: String
}
