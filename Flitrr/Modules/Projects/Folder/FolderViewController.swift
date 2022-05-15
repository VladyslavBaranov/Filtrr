//
//  FolderViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 15.05.2022.
//

import UIKit

final class FolderViewController: UIViewController {
    
    var folder: FolderProtocol!
    private var closeButton: UIButton!
    private var navigationView: NavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopUI()
    }
    
    func setupTopUI() {
        view.backgroundColor = .appDark
        closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        navigationView = NavigationView(frame: .zero)
        navigationView.title = folder.name ?? ""
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.heightAnchor.constraint(equalToConstant: 80),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: closeButton.bottomAnchor)
        ])
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
}
