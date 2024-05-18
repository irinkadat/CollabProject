//
//  SolarResourceViewController.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import Foundation
import UIKit

protocol SolarResourceViewControllerDelegate: AnyObject {
    func didRequestSolarData(lat: Double, lon: Double)
}

class SolarResourceViewController: UIViewController {
    
    //MARK: - Properties
    
    var button = UIButton()
    var titleLabel = UILabel()
    var latTextField = UITextField()
    var lonTextField = UITextField()
    var avgDniLabel = UILabel()
    var avgGhiLabel = UILabel()
    var avgTiltLabel = UILabel()
    var errorLabel = UILabel()
    
    private var viewModel = SolarResourceViewModel()
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupUi()
        //button.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.fetchData()
        }), for: .touchUpInside)
    }
    
    //MARK: - UI configuration

    private func setupUi() {
        
        CustomComponents.configureTextField(textField: latTextField, placeholder: "Enter Latitude")
        CustomComponents.configureTextField(textField: lonTextField, placeholder: "Enter Longitude")
        CustomComponents.configureButton(button: button)
        CustomComponents.configureLabel(titleLabel, textSize: 44)
        titleLabel.text = "Solar Data"

        CustomComponents.configureLabel(avgDniLabel)
        CustomComponents.configureLabel(avgGhiLabel)
        CustomComponents.configureLabel(avgTiltLabel)
        CustomComponents.configureLabel(errorLabel)
        
        errorLabel.textColor = .red
        button.setTitle("Get Solar Data", for: .normal)
        view.addSubview(latTextField)
        view.addSubview(lonTextField)
        view.addSubview(titleLabel)
        view.addSubview(button)
        view.addSubview(avgDniLabel)
        view.addSubview(avgTiltLabel)
        view.addSubview(avgGhiLabel)
        view.addSubview(errorLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        latTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        lonTextField.topAnchor.constraint(equalTo: latTextField.bottomAnchor, constant: 20).isActive = true
        button.topAnchor.constraint(equalTo: lonTextField.bottomAnchor, constant: 50).isActive = true
        avgDniLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20).isActive = true
        avgGhiLabel.topAnchor.constraint(equalTo: avgDniLabel.bottomAnchor, constant: 20).isActive = true
        avgTiltLabel.topAnchor.constraint(equalTo: avgGhiLabel.bottomAnchor, constant: 20).isActive = true
        errorLabel.topAnchor.constraint(equalTo: avgTiltLabel.bottomAnchor, constant: 20).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        latTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lonTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avgDniLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avgGhiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        avgTiltLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true



        
    }
    
    //MARK: - Networking function

    private func fetchData() {
        guard let latText = latTextField.text, let lonText = lonTextField.text,
              let lat = Double(latText), let lon = Double(lonText) else {
            errorLabel.text = "Please enter valid coordinates."
            return
        }
        
        viewModel.fetchSolarData(lat: lat, lon: lon) { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    //MARK: - Updating UI

    private func updateUI() {
        if let solarResource = viewModel.solarResource {
            avgDniLabel.text = "Average DNI: \(solarResource.avgDNI.annual)"
            avgGhiLabel.text = "Average GHI: \(solarResource.avgGHI.annual)"
            avgTiltLabel.text = "Average Tilt at Latitude: \(solarResource.avgTilt.annual)"
            errorLabel.text = ""
        } else if let errorMessage = viewModel.errorMessage {
            errorLabel.text = errorMessage
            avgDniLabel.text = ""
            avgGhiLabel.text = ""
            avgTiltLabel.text = ""
        }
    }
}

//MARK: - Extensions

extension SolarResourceViewController: SolarResourceViewControllerDelegate {
    func didRequestSolarData(lat: Double, lon: Double) {
        viewModel.fetchSolarData(lat: lat, lon: lon) {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
}
