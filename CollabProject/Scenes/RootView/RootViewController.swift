//
//  RootViewController.swift
//  CollabProject
//
//  Created by Irinka Datoshvili on 17.05.24.
//
import UIKit

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    func setUpTabBar() {
        
        let tabBarController = UITabBarController()
        let airQualityVC = AirQualityViewController()
        let weatherVC = WeatherViewController()
        let speciesVC = SpecieViewController()
        let solarResourceVC = SolarResourceViewController()
        let populationVC = PopulationViewController()
        
        tabBarController.viewControllers = [
            airQualityVC,
            weatherVC,
            speciesVC,
            solarResourceVC,
            populationVC
        ]
        
        airQualityVC.tabBarItem = UITabBarItem(title: "AQI", image: UIImage(systemName: "aqi.high"), tag: 0)
        weatherVC.tabBarItem = UITabBarItem(title: "Weather", image: UIImage(systemName: "cloud.sun"), tag: 1)
        speciesVC.tabBarItem = UITabBarItem(title: "Species", image: UIImage(systemName: "tortoise"), tag: 2)
        solarResourceVC.tabBarItem = UITabBarItem(title: "Solar", image: UIImage(systemName: "sun.max"), tag: 3)
        populationVC.tabBarItem = UITabBarItem(title: "Population", image: UIImage(systemName: "person.2"), tag: 4)
        
        tabBarController.tabBar.barTintColor = UIColor(red: 58/255, green: 137/255, blue: 255/255, alpha: 1.0)
        tabBarController.tabBar.tintColor = UIColor(named: "buttonColor")
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
    }
}


