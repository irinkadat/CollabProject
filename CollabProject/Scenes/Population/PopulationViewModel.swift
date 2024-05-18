import Foundation

class PopulationViewModel {
    private let baseURL = "https://d6wn6bmjj722w.population.io:443/1.0/population/"
    
    func fetchPopulation(for country: String, completion: @escaping (Result<(today: Int, tomorrow: Int), Error>) -> Void) {
        let url = URL(string: "\(baseURL)\(country)/today-and-tomorrow/")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "PopulationViewModelError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let populationData = try JSONDecoder().decode(PopulationResponse.self, from: data)
                if populationData.totalPopulation.count >= 2 {
                    let todayPopulation = populationData.totalPopulation[0].population
                    let tomorrowPopulation = populationData.totalPopulation[1].population
                    completion(.success((todayPopulation, tomorrowPopulation)))
                } else {
                    completion(.failure(NSError(domain: "PopulationViewModelError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Insufficient data"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

