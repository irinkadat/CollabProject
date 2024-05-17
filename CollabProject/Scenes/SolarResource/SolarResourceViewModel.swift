//
//  SolarResourceViewModel.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import Foundation
import NetworkServicePackage

enum NetworkError: Error {
    case decodeError
    case wrongResponse
    case wrongStatusCode(code: Int)
}

class SolarResourceViewModel {
    private let networkService = NetworkService()
    
    var solarResource: SolarResource?
    var errorMessage: String?
    
    func fetchSolarData(lat: Double, lon: Double, completion: @escaping () -> Void) {
        
        let apiKey = "mMr92fVY2ufTiwB7OSejbDAKfHlqMriS36PucvnF"
        let baseURL = "https://developer.nrel.gov/api/solar/solar_resource/v1.json"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "attributes", value: "avg_dni,avg_ghi,avg_tilt_at_latitude")
        ]
        
        guard let url = components.url else {
            self.errorMessage = "Url is not correct"
            completion()
            return
        }
        
        networkService.getData(urlString: url.absoluteString) { [weak self] (result: Result<SolarResourceResponse, Error>) in
            switch result {
            case .success(let response):
                self?.solarResource = response.outputs
            case .failure(let error as NetworkError):
                switch error {
                case .decodeError:
                    self?.errorMessage = "Failed to decode response"
                case .wrongResponse:
                    self?.errorMessage = "Received wrong response"
                case .wrongStatusCode(let code):
                    self?.errorMessage = "Received wrong status code: \(code)"
                }
            case .failure(let error):
                print("Other Error: \(error)")
                self?.errorMessage = error.localizedDescription
            }
            completion()
        }
    }
  
}

extension SolarResourceViewModel: SolarResourceViewControllerDelegate {
    func didRequestSolarData(lat: Double, lon: Double) {
        func didRequestSolarData(lat: Double, lon: Double) {
            fetchSolarData(lat: lat, lon: lon) {
            }
        }
    }
    
    
}
