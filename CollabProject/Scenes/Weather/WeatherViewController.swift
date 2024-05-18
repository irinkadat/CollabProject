//
//  WeatherViewController.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //    MARK: - Variables
    
    private var viewModel = WeatherViewModel()
    
    //    MARK: - UI Components
    
    private let weatherTitle = UILabel()
    private let textField = UITextField()
    private let searchButton = UIButton()
    private let summaryLabel =  UILabel()
    private var labelViews: [UILabel] = []
    private var contentLabelViews: [UILabel] = []
    
    // MARK: - Stackview
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelsStackView, contentStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupUI()
        setupLabels()
        searchButton.addAction(UIAction(handler: { [weak self] _ in
            self?.searchButtonTapped()}), for: .touchUpInside)
    }
    
    //    MARK: - SetUp UI
    
    private func setupUI() {
        CustomComponents.configureLabel(weatherTitle, textSize: 44)
        weatherTitle.text = "Weather"
        CustomComponents.configureTextField(textField: textField, placeholder: "Enter City")
        CustomComponents.configureButton(button: searchButton)
        searchButton.setTitle("Get Weather Forecast", for: .normal)
        CustomComponents.configureLabel(summaryLabel, textSize: 15)
        addViews()
    }
    
    func addViews() {
        self.view.addSubview(weatherTitle)
        self.view.addSubview(textField)
        self.view.addSubview(searchButton)
        self.view.addSubview(horizontalStackView)
        self.view.addSubview(summaryLabel)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            weatherTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            summaryLabel.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 20),
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
    }
    
    //    MARK: - Networking
    
    private func searchButtonTapped() {
        guard let location = textField.text else { return }
        getWeatherForecast(for: location)
    }
    
    private func getWeatherForecast(for location: String) {
        viewModel.getWeatherForecast(for: location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.updateUI()
                case .failure(let error):
                    print("Failed to get forecast:", error)
                }
            }
        }
    }
    
    //    MARK: - UI and StackView Update
    
    private func setupLabels() {
        let labelTitles = [
            "Timezone:", "Min Temp:", "Max Temp:", "Humidity:", "Wind Speed:",
            "Description:", "Clouds:", "Rain:"
        ]
        
        for title in labelTitles {
            let label = makeLabel(text: title)
            let contentLabel = makeContentLabel(text: "")
            labelsStackView.addArrangedSubview(label)
            contentStackView.addArrangedSubview(contentLabel)
            labelViews.append(label)
            contentLabelViews.append(contentLabel)
        }
    }
    
    private func updateUI() {
        summaryLabel.text = viewModel.summaryLabelText
        updateLabels()
    }
    
    private func updateLabels() {
        let contentTexts = [
            viewModel.timezoneLabelText,
            viewModel.minTempLabelText,
            viewModel.maxTempLabelText,
            viewModel.humidityLabelText,
            viewModel.windSpeedLabelText,
            viewModel.descriptionLabelText,
            viewModel.cloudsLabelText,
            viewModel.rainLabelText
        ]
        
        for (index, contentText) in contentTexts.enumerated() {
            contentLabelViews[index].text = contentText
        }
    }
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "FiraGO-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = text
        return label
    }
    
    private func makeContentLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "FiraGO-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        label.text = text
        return label
    }
    
}
