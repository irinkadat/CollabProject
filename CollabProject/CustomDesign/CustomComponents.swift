//
//  CustomComponents.swift
//  CollabProject
//
//  Created by M1 on 18.05.2024.
//

import UIKit

class CustomComponents {
    
    static func configureTextField(textField: UITextField , placeholder: String) {
        textField.translatesAutoresizingMaskIntoConstraints = false
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
    
    static func configureLabel(_ label: UILabel, textSize: Int = 14) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "FiraGO-Medium", size: CGFloat(textSize)) ?? UIFont.systemFont(ofSize: CGFloat(textSize), weight: .medium)
    }
    
    static func configureButton(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 350).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.backgroundColor = UIColor(named: "buttonColor")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "FiraGO-Medium", size: 14) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
}
