//
//  Weather.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import Foundation

struct Forecast: Codable {
    let timezone: String
    struct Daily: Codable {
        let dt: Date
        let summary: String
        struct Temp: Codable {
            let min: Double
            let max: Double
        }
        let temp: Temp
        let humidity: Int
        let wind_speed: Double
        struct Weather: Codable {
            let id: Int
            let description: String
        }
        let weather: [Weather]
        let clouds: Int
        let rain: Double?
    }
    let daily: [Daily]
}
