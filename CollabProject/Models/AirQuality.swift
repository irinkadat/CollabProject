//
//  AirQuality.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import Foundation

struct AirQuality: Decodable {
    let city: String
    let state: String
    let country: String
    let aqi: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case city
        case state
        case country
        case current
        case pollution
        case aqius
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        city = try dataContainer.decode(String.self, forKey: .city)
        state = try dataContainer.decode(String.self, forKey: .state)
        country = try dataContainer.decode(String.self, forKey: .country)
        let currentContainer = try dataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .current)
        let pollutionContainer = try currentContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .pollution)
        aqi = try pollutionContainer.decode(Int.self, forKey: .aqius)
    }
}
