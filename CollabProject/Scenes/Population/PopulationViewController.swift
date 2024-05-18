import UIKit

class PopulationViewController: UIViewController {
    // MARK: - Properties
    
    private let countryTextField = UITextField()
    private let todayPopulationLabel = UILabel()
    private let tomorrowPopulationLabel = UILabel()
    private let fetchButton = UIButton(type: .system)
    
    private let viewModel = PopulationViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupUI()
        addViews()
        setupConstraints()
        addActions()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        let titleLabel = UILabel()
        CustomComponents.configureLabel(titleLabel, textSize: 44)
        titleLabel.text = "Population"
        titleLabel.textColor = .white
        
        CustomComponents.configureTextField(textField: countryTextField, placeholder: "Enter country name")
        
        CustomComponents.configureLabel(todayPopulationLabel, textSize: 14)
        todayPopulationLabel.text = "Today: "
        
        CustomComponents.configureLabel(tomorrowPopulationLabel, textSize: 14)
        tomorrowPopulationLabel.text = "Tomorrow: "
        
        CustomComponents.configureButton(button: fetchButton)
        fetchButton.setTitle("Get Population Data", for: .normal)
        
        
        view.addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Add Views
    
    private func addViews() {
        view.addSubview(countryTextField)
        view.addSubview(todayPopulationLabel)
        view.addSubview(tomorrowPopulationLabel)
        view.addSubview(fetchButton)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            countryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            countryTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            fetchButton.topAnchor.constraint(equalTo: countryTextField.bottomAnchor, constant: 20),
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.widthAnchor.constraint(equalToConstant: 350),
            fetchButton.heightAnchor.constraint(equalToConstant: 55),
            
            todayPopulationLabel.topAnchor.constraint(equalTo: fetchButton.bottomAnchor, constant: 20),
            todayPopulationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            todayPopulationLabel.widthAnchor.constraint(equalToConstant: 300),
            todayPopulationLabel.heightAnchor.constraint(equalToConstant: 50),
            
            tomorrowPopulationLabel.topAnchor.constraint(equalTo: todayPopulationLabel.bottomAnchor, constant: 20),
            tomorrowPopulationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tomorrowPopulationLabel.widthAnchor.constraint(equalToConstant: 300),
            tomorrowPopulationLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Actions
    
    private func addActions() {
        fetchButton.addAction(UIAction { [weak self] _ in
            self?.fetchPopulation()
        }, for: .touchUpInside)
    }
    
    // MARK: - Networking
    
    private func fetchPopulation() {
        guard let country = countryTextField.text, !country.isEmpty else {
            displayError("Please enter a country name")
            return
        }
        
        viewModel.fetchPopulation(for: country) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let populations):
                    self?.todayPopulationLabel.text = "Today: \(populations.today)"
                    self?.tomorrowPopulationLabel.text = "Tomorrow: \(populations.tomorrow)"
                case .failure(let error):
                    self?.displayError(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Error Handling
    
    private func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

