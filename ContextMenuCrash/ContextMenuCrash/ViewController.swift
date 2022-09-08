//
//  ViewController.swift
//  ContextMenuCrash
//
//  Created by Johannes Fahrenkrug on 9/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 96, weight: .regular)
        
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.clearButtonMode = .always
        textField.layer.cornerRadius = 5
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor.white
        
        textField.font = UIFont.systemFont(ofSize: 48)
        
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(textField)
        
        titleLabel.text = "💥💥💥"
        
        view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00) // light gray
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 300)
        ])
    }


}

