//
//  AirQualityViewModel.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import Foundation
import NetworkServicePackage

protocol AirQualityViewModelDelegate: AnyObject {
    func showInvalidCoordinatesAlert()
}

class AirQualityViewModel {
    
    // MARK: - Properties
    
    weak var delegate: AirQualityViewModelDelegate?
    var airQuality: AirQuality?
    var errorMessage: String?
    
    var cityLabelText: String? {
        guard let city = airQuality?.city else {
            return nil
        }
        return "City: \(city)"
    }
    
    var stateLabelText: String? {
        guard let state = airQuality?.state else {
            return nil
        }
        return "State: \(state)"
    }
    
    var countryLabelText: String? {
        guard let country = airQuality?.country else {
            return nil
        }
        return "Country: \(country)"
    }
    
    var aqiLabelText: String? {
        guard let aqi = airQuality?.aqi else {
            return nil
        }
        return "AQI: \(aqi)"
    }
    
    var errorLabelText: String? {
        return errorMessage
    }
    
    private let apiKey = "86b5f167-f3e9-497c-abea-bd58ba291343"
    private let networkService = NetworkService()
    
    // MARK: - Network Methods
    
    func fetchAirQuality(lat: Double, lon: Double, completion: @escaping (Result<AirQuality, Error>) -> Void) {
        guard validateCoordinates(latitude: lat, longitude: lon) else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid coordinates"])
            completion(.failure(error))
            return
        }
        
        let urlString = "https://api.airvisual.com/v2/nearest_city?lat=\(lat)&lon=\(lon)&key=\(apiKey)"
        
        networkService.getData(urlString: urlString) { (result: Result<AirQuality, Error>) in
            switch result {
            case .success(let airQuality):
                completion(.success(airQuality))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func validateAndFetchAirQuality(lat: Double, lon: Double, completion: @escaping (Result<AirQuality, Error>) -> Void) {
        if validateCoordinates(latitude: lat, longitude: lon) {
            fetchAirQuality(lat: lat, lon: lon, completion: completion)
        } else {
            delegate?.showInvalidCoordinatesAlert()
        }
    }
    
    // MARK: - Validation Methods
    
    func validateCoordinates(latitude: Double?, longitude: Double?) -> Bool {
        guard let latitude = latitude, let longitude = longitude else {
            return false
        }
        
        return (latitude >= -90 && latitude <= 90) && (longitude >= -180 && longitude <= 180) && (latitude != 0 && longitude != 0)
    }
}
