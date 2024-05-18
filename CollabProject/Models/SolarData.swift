//
//  SolarData.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import Foundation

struct MonthlyAverages: Codable {
    let jan: Double
    let feb: Double
    let mar: Double
    let apr: Double
    let may: Double
    let jun: Double
    let jul: Double
    let aug: Double
    let sep: Double
    let oct: Double
    let nov: Double
    let dec: Double
}

struct AvgDNI: Codable {
    let annual: Double
    let monthly: MonthlyAverages
}

struct AvgGHI: Codable {
    let annual: Double
    let monthly: MonthlyAverages
}

struct AvgTilt: Codable {
    let annual: Double
    let monthly: MonthlyAverages
}

struct SolarResource: Codable {
    let avgDNI: AvgDNI
    let avgGHI: AvgGHI
    let avgTilt: AvgTilt
    
    enum CodingKeys: String, CodingKey {
        case avgDNI = "avg_dni"
        case avgGHI = "avg_ghi"
        case avgTilt = "avg_lat_tilt"
    }
}

struct SolarResourceResponse: Codable {
    let outputs: SolarResource
}
