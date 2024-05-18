struct PopulationResponse: Codable {
    let totalPopulation: [Population]
    
    enum CodingKeys: String, CodingKey {
        case totalPopulation = "total_population"
    }
}

struct Population: Codable {
    let date: String
    let population: Int
}


