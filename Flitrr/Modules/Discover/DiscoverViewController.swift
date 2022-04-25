//
//  ViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.04.2022.
//

import UIKit

class DiscoverViewController: UIViewController {

    private var navigationView: NavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appDark
        
        tabBarController?.tabBar.isHidden = true
        
        setupTopViews()
    }
    
    func setupTopViews() {
        navigationView = NavigationView(frame: .zero)
        navigationView.title = "Discover"
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.heightAnchor.constraint(equalToConstant: 80),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

