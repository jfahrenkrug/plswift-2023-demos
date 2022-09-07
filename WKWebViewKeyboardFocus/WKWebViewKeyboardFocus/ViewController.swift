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
    
    private lazy var focusButton: UIButton = {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold, scale: .large)
        let button = UIButton(type: .system, primaryAction: UIAction(title: "Focus from Native", image: UIImage(systemName: "keyboard", withConfiguration: symbolConfig), handler: { _ in
            print("Button tapped!")
            self.focusTextField()
        }))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WebViewKeyboardFocusHelper.applyKeyboardFocusFixIfNeeded()
        
        view.addSubview(webView)
        view.addSubview(focusButton)
        view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00) // light gray
        
        if let demoFileURL = Bundle.main.url(forResource: "demo", withExtension: "html") {
            webView.loadFileURL(demoFileURL, allowingReadAccessTo: demoFileURL)
        }
        
        let views = ["webView": webView, "button": focusButton]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]-(20)-[button]-(100)-|", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[button]-|", metrics: nil, views: views))
    }
    
    private func focusTextField() {
        webView.evaluateJavaScript("document.getElementById('textfield').focus()") { res, error in
            print("JS evaluated.")
            
            if let res = res {
                print("Res: \(res)")
            }
            
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
}
