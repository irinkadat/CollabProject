//
//  SpecieViewModel.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import Foundation
import NetworkServicePackage


class SpecieViewModel {
    //MARK: Properties
    var species: [ResultForSpecies] = [] {
        didSet {
            onSpeciesFetched?()
        }
    }
    var errorMessage: String? {
        didSet {
            if let errorMessage = errorMessage {
                onError?(errorMessage)
            }
        }
    }
    var onSpeciesFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    
    //MARK: Functions
    func fetchCityID(cityName: String) {
        let urlString = "https://api.inaturalist.org/v1/places/autocomplete?q=\(cityName)"
        NetworkService().getData(urlString: urlString) { [weak self] (result: Result<Cities, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let cities):
                if let cityID = cities.results.first?.id {
                    self.fetchSpecies(for: cityID)
                } else {
                    self.errorMessage = "City not found."
                }
            case .failure(let error):
                self.errorMessage = "Error fetching city ID: \(error)"
            }
        }
    }
    
    private func fetchSpecies(for cityID: Int) {
        let urlString = "https://api.inaturalist.org/v1/observations/species_counts?place_id=\(cityID)"
        NetworkService().getData(urlString: urlString) { [weak self] (result: Result<Species, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let species):
                self.species = species.results
            case .failure(let error):
                self.errorMessage = "Error fetching species: \(error)"
            }
        }
    }
}
