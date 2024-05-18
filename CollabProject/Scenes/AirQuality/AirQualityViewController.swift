//
//  AirQualityViewController.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import UIKit

class AirQualityViewController: UIViewController, AirQualityViewModelDelegate {
    
    // MARK: - Properties
    
    private var viewModel = AirQualityViewModel()
    private let cityLabel = UILabel()
    private let stateLabel = UILabel()
    private let countryLabel = UILabel()
    private let aqiLabel = UILabel()
    private let errorLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let latTextField = UITextField()
    private let lonTextField = UITextField()
    private let fetchButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        configureHeader()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        configureTextField(textField: latTextField, placeholder: "Enter latitude")
        configureTextField(textField: lonTextField, placeholder: "Enter longitude")
        
        fetchButton.addAction(UIAction(handler: { [weak self] _ in
            self?.fetchButtonTapped()
        }), for: .touchUpInside)
        
        configureLabel(cityLabel)
        configureLabel(stateLabel)
        configureLabel(countryLabel)
        configureLabel(aqiLabel)
        configureLabel(errorLabel)
        errorLabel.textColor = .red
        
        let inputStackView = UIStackView(arrangedSubviews: [latTextField, lonTextField])
        inputStackView.axis = .vertical
        inputStackView.spacing = 10
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [inputStackView, fetchButton, cityLabel, stateLabel, countryLabel, aqiLabel, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        configureButton()
    }
    
    private func configureHeader() {
        configureLabel(titleLabel, textSize: 44)
        titleLabel.text = "Air Quality"
        view.addSubview(titleLabel)
        
        configureLabel(descriptionLabel, textSize: 16)
        descriptionLabel.text = "Air quality refers to the condition of the air within our surroundings. It is determined by various factors such as the presence of pollutants, pollutants' concentration, and weather conditions."
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Configuration Methods
    
    private func configureTextField(textField: UITextField, placeholder: String) {
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
        
        textField.font = UIFont(name: "FiraGO-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14)
    }
    
    private func configureLabel(_ label: UILabel, textSize: Int = 14) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "FiraGO-Medium", size: CGFloat(textSize)) ?? UIFont.systemFont(ofSize: CGFloat(textSize), weight: .medium)
    }
    
    private func configureButton() {
        fetchButton.widthAnchor.constraint(equalToConstant: 350).isActive = true
        fetchButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        fetchButton.backgroundColor = UIColor(named: "buttonColor")
        fetchButton.setTitleColor(.white, for: .normal)
        fetchButton.setTitle("Fetch Air Quality", for: .normal)
        fetchButton.layer.cornerRadius = 10
        fetchButton.titleLabel?.font = UIFont(name: "FiraGO-Medium", size: 14) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    // MARK: - Action Methods
    
    func fetchButtonTapped() {
        guard let latText = latTextField.text, let lat = Double(latText),
              let lonText = lonTextField.text, let lon = Double(lonText) else {
            showInvalidCoordinatesAlert()
            return
        }
        
        viewModel.validateAndFetchAirQuality(lat: lat, lon: lon) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let airQuality):
                    self?.viewModel.airQuality = airQuality
                    self?.updateUI()
                case .failure(let error):
                    self?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - UI Update Methods
    
    private func updateUI() {
        cityLabel.text = viewModel.cityLabelText
        stateLabel.text = viewModel.stateLabelText
        countryLabel.text = viewModel.countryLabelText
        aqiLabel.text = viewModel.aqiLabelText
        errorLabel.text = viewModel.errorLabelText
    }
    
    private func showError(_ message: String) {
        errorLabel.text = "Error: \(message)"
        cityLabel.text = ""
        stateLabel.text = ""
        countryLabel.text = ""
        aqiLabel.text = ""
    }
    
    // MARK: - AirQualityViewModelDelegate
    
    func showInvalidCoordinatesAlert() {
        let alert = UIAlertController(title: "Invalid Coordinates", message: "Please enter valid latitude and longitude values.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
