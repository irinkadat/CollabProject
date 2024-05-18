
//  SpecieViewController.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import UIKit

class SpecieViewController: UIViewController {
    
    //MARK: - Properties
    
    var button = UIButton()
    var titleLabel = UILabel()
    var cityTextField = UITextField()
    var speciesName = UILabel()
    var speciesAncestry = UILabel()
    var speciesPhoto = UIImageView()
    var speciesWiki = UILabel()
    var errorLabel = UILabel()
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "species")
        return image
    }()
    private var viewModel = SpecieViewModel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupUi()
        bindViewModel()
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.fetchData()
        }), for: .touchUpInside)
    }
    
    //MARK: - Functions
    
    private func setupUi() {
        CustomComponents.configureTextField(textField: cityTextField, placeholder: "Enter City")
        CustomComponents.configureButton(button: button)
        CustomComponents.configureLabel(titleLabel, textSize: 44)
        titleLabel.text = "Species Data"
        CustomComponents.configureLabel(speciesName, textSize: 15)
        speciesName.text = "Specie Name"
        CustomComponents.configureLabel(speciesAncestry, textSize: 15)
        speciesAncestry.text = "Info Author"
        CustomComponents.configureLabel(speciesWiki, textSize: 15)
        speciesWiki.text = "Wikipedia Url"
        CustomComponents.configureLabel(errorLabel, textSize: 10)
        errorLabel.text = ""
        addViews()
    }
    
    func addViews() {
        view.addSubview(cityTextField)
        view.addSubview(button)
        view.addSubview(speciesWiki)
        view.addSubview(titleLabel)
        view.addSubview(speciesName)
        view.addSubview(speciesAncestry)
        view.addSubview(imageView)
        view.addSubview(errorLabel)
        configureImage()
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            speciesName.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            speciesName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speciesAncestry.topAnchor.constraint(equalTo: speciesName.bottomAnchor, constant: 8),
            speciesAncestry.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speciesWiki.topAnchor.constraint(equalTo: speciesAncestry.bottomAnchor, constant: 8),
            speciesWiki.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureImage() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: speciesWiki.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func bindViewModel() {
         viewModel.onSpeciesFetched = { [weak self] in
             DispatchQueue.main.async {
                 self?.updateUI()
             }
         }
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.errorLabel.text = errorMessage
            }
        }
     }

     private func updateUI() {
         if let species = viewModel.species.first {
             speciesName.text = species.taxon.name
             speciesAncestry.text = species.taxon.defaultPhoto.attribution
             speciesWiki.text = species.taxon.wikipediaURL
             imageView.setImage(with: species.taxon.defaultPhoto.mediumURL)
         }
     }

    private func fetchData() {
         guard let cityName = cityTextField.text, !cityName.isEmpty else {
             errorLabel.text = "Please enter a city name."
             return
         }
         viewModel.fetchCityID(cityName: cityTextField.text ?? "Tbilisi")
     }
}
