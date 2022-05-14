//
//  ViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.04.2022.
//

import UIKit

class DiscoverViewController: UIViewController {

    private var navigationView: NavigationView!
    var searchTextField: UISearchTextField!
    
    var paywallWasShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appDark
        
        tabBarController?.tabBar.isHidden = true
        
        setupTopViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !paywallWasShown {
            paywallWasShown = true
            let controller = PaywallHostingController(rootView: PaywallView())
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        }
    }
    
    func setupTopViews() {
        navigationView = NavigationView(frame: .zero)
        navigationView.title = "Discover"
        navigationView.translatesAutoresizingMaskIntoConstraints = false
		navigationView.onSettingsButtonTapped = openSettings
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.heightAnchor.constraint(equalToConstant: 80),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        searchTextField = UISearchTextField()
        searchTextField.backgroundColor = .appDark
        searchTextField.placeholder = "Search Templates"
        searchTextField.clearButtonMode = .whileEditing
        view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            searchTextField.topAnchor.constraint(equalTo: navigationView.bottomAnchor)
        ])
    }
	
	func openSettings() {
		
		let nav = SettingsViewController.createSettingsNavigationController()
		nav.modalPresentationStyle = .fullScreen
		present(nav, animated: true)
	}
}

