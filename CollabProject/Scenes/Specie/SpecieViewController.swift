
//  SpecieViewController.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//

import UIKit

class SpecieViewController: UIViewController {
    //MARK: Properties:
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
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupUi()
        bindViewModel()
        button.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
    }
    
    //MARK: Functions
    private func setupUi() {
        cityTextField = configureTextField(placeholder: "Enter City", topAnchor: view.topAnchor, constant: 200)
        configureButton()
        configureLabel(titleLabel, topAnchor: view.topAnchor, constant: 100, text: "Species Data", textSize: 44)
        titleLabel.textColor = .white
        configureLabel(speciesName, topAnchor: button.bottomAnchor, constant: 8, text: "Specie Name", textSize: 15)
        configureLabel(speciesAncestry, topAnchor: speciesName.bottomAnchor, constant: 8, text: "Info Author", textSize: 15)
        configureLabel(speciesWiki, topAnchor: speciesAncestry.bottomAnchor, constant: 8, text: "Wikipedia Url", textSize: 15)
        configureImage()
        configureLabel(errorLabel, topAnchor: imageView.bottomAnchor, constant: 8, text: "", textSize: 10)
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
    
    private func configureButton() {
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 350).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        button.backgroundColor = UIColor(named: "buttonColor")
        button.setTitle("Get Species Data", for: .normal)
        button.layer.cornerRadius = 10
        
        button.titleLabel?.font = UIFont(name: "FiraGO-Medium", size: 14)
        
        button.layer.shadowColor = UIColor(named: "buttonColor")?.cgColor
        button.layer.shadowOpacity = 0.32
        button.layer.shadowOffset = CGSize(width: 0, height: 3.77)
        button.layer.shadowRadius = 11.32 / 2.0
    }
    
    private func configureImage() {
        view.addSubview(imageView)
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

     @objc private func fetchData() {
         guard let cityName = cityTextField.text, !cityName.isEmpty else {
             errorLabel.text = "Please enter a city name."
             return
         }
         viewModel.fetchCityID(cityName: cityTextField.text ?? "Tbilisi")
     }
}
