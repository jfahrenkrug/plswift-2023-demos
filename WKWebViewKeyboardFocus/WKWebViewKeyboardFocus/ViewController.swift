//
//  ViewController.swift
//  WKWebViewKeyboardFocus
//
//  Created by Johannes Fahrenkrug on 9/1/22.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    private let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let focusButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold, scale: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("I want to type!", for: .normal)
        button.setImage(UIImage(systemName: "keyboard", withConfiguration: symbolConfig), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.addSubview(focusButton)
        view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00) // light gray
        
        let views = ["webView": webView, "button": focusButton]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]-(20)-[button]-(100)-|", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[button]-|", metrics: nil, views: views))
    }


}

