//
//  WeatherViewModel.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import Foundation
import NetworkServicePackage
import CoreLocation

class WeatherViewModel {
    
    //    MARK: - Variables
    
    var forecast: Forecast?
    private let networkService = NetworkService()
    private let apiKey = "e3e1cdc2c1f52476d9a0fcb7454a9d4e"
    
    var summaryLabelText: String {
        return forecast?.daily.first?.summary ?? ""
    }
    
    var timezoneLabelText: String {
        return forecast?.timezone ?? "N/A"
    }
    
    var minTempLabelText: String {
        guard let minTemp = forecast?.daily.first?.temp.min else { return "N/A" }
        return "\(minTemp) K"
    }
    
    var maxTempLabelText: String {
        guard let maxTemp = forecast?.daily.first?.temp.max else { return "N/A" }
        return "\(maxTemp) K"
    }
    
    var humidityLabelText: String {
        guard let humidity = forecast?.daily.first?.humidity else { return "N/A" }
        return "\(humidity) %"
    }
    
    var windSpeedLabelText: String {
        guard let windSpeed = forecast?.daily.first?.wind_speed else { return "N/A" }
        return "\(windSpeed) m/s"
    }
    
    var descriptionLabelText: String {
        return forecast?.daily.first?.weather.first?.description ?? "N/A"
    }
    
    var cloudsLabelText: String {
        guard let clouds = forecast?.daily.first?.clouds else { return "N/A" }
        return "\(clouds) %"
    }
    
    var rainLabelText: String {
        guard let rain = forecast?.daily.first?.rain else { return "N/A" }
        return "\(rain) mm"
    }
    
    //    MARK: - Networking
    
    func getWeatherForecast(for location: String, completion: @escaping (Result<Forecast, Error>) -> Void) {
        CLGeocoder().geocodeAddressString(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
            } else if let placemark = placemarks?.first {
                self.fetchWeatherForecast(from: placemark, completion: completion)
            } else {
                let error = NSError(domain: "", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No placemarks found"])
                completion(.failure(error))
            }
        }
    }
    
    private func fetchWeatherForecast(from placemark: CLPlacemark,
                                      completion: @escaping (Result<Forecast, Error>) -> Void) {
        guard let lat = placemark.location?.coordinate.latitude,
              let lon = placemark.location?.coordinate.longitude else {
            let error = NSError(domain: "", code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid coordinates"])
            completion(.failure(error))
            return
        }
        
        let baseURL = "https://api.openweathermap.org/data/3.0/onecall"
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "exclude", value: "current,minutely,hourly,alerts"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        guard let url = components.url else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        networkService.getData(urlString: url.absoluteString) { (result: Result<Forecast, Error>) in
            switch result {
            case .success(let forecast):
                self.forecast = forecast
                completion(.success(forecast))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
