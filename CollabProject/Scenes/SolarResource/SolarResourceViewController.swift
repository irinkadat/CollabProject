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
    
    var button = UIButton()
    var titleLabel = UILabel()
    var latTextField = UITextField()
    var lonTextField = UITextField()
    var avgDniLabel = UILabel()
    var avgGhiLabel = UILabel()
    var avgTiltLabel = UILabel()
    var errorLabel = UILabel()
    
    private var viewModel = SolarResourceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupUi()
        button.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
    }
    
    private func setupUi() {
        latTextField = configureTextField(placeholder: "Enter Latitude", topAnchor: view.topAnchor, constant: 200)
        lonTextField = configureTextField(placeholder: "Enter Longitude", topAnchor: latTextField.bottomAnchor, constant: 20)
        
        configureButton()
        configureLabel(titleLabel, topAnchor: view.topAnchor, constant: 100, text: "Solar Data", textSize: 44)
        titleLabel.textColor = .white
        configureLabel(avgDniLabel, topAnchor: button.bottomAnchor, constant: 20)
        configureLabel(avgGhiLabel, topAnchor: avgDniLabel.bottomAnchor, constant: 20)
        configureLabel(avgTiltLabel, topAnchor: avgGhiLabel.bottomAnchor, constant: 20)
        configureLabel(errorLabel, topAnchor: avgTiltLabel.bottomAnchor, constant: 20)
        
        errorLabel.textColor = .red
    }
    
    private func configureButton() {
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: lonTextField.bottomAnchor, constant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 350).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        button.backgroundColor = UIColor(named: "buttonColor")
        button.setTitle("Get Solar Data", for: .normal)
        button.layer.cornerRadius = 10
        
        button.titleLabel?.font = UIFont(name: "FiraGO-Medium", size: 14)
        
        button.layer.shadowColor = UIColor(named: "buttonColor")?.cgColor
        button.layer.shadowOpacity = 0.32
        button.layer.shadowOffset = CGSize(width: 0, height: 3.77)
        button.layer.shadowRadius = 11.32 / 2.0
            
    }
    
    private func configureTextField(placeholder: String, topAnchor: NSLayoutYAxisAnchor, constant: CGFloat) -> UITextField {
        let textField = UITextField()
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 350).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "FiraGO-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        
        textField.backgroundColor = UIColor(named: "inputTextFieldColor")
        textField.textColor = .lightGray
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.font = UIFont(name: "FiraGO-Medium", size: 14)
        
        return textField
    }
    
    
    private func configureLabel(_ label: UILabel, topAnchor: NSLayoutYAxisAnchor, constant: CGFloat, text: String = "", textSize: Int = 14) {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        label.text = text
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "FiraGO-Medium", size: CGFloat(textSize))
    }
    
    @objc private func fetchData() {
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

extension SolarResourceViewController: SolarResourceViewControllerDelegate {
    func didRequestSolarData(lat: Double, lon: Double) {
        viewModel.fetchSolarData(lat: lat, lon: lon) {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
}
