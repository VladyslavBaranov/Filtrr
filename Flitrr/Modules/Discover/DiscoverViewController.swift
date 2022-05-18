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
    // private var discoverPicker: ValuePickerView!
    var collectionView: UICollectionView!
    
    var paywallWasShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appDark
        
        tabBarController?.tabBar.isHidden = true
        
        setupCollection()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // discoverPicker.frame = .init(x: 0, y: view.safeAreaInsets.top + 130, width: view.bounds.width, height: 80)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
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
    
    /*func setupDiscoverPicker() {
        discoverPicker = ValuePickerView(
            frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
        discoverPicker.titles = ["Christmas", "Inspiration", "Cyber Monday"]
        discoverPicker.isTransparentAppearance = true
        discoverPicker.leftInset = 13
        discoverPicker.itemHeight = 40
        discoverPicker.pickerStyle = .style2
        view.addSubview(discoverPicker)
    }*/
	
	func openSettings() {
		
		let nav = SettingsViewController.createSettingsNavigationController()
		nav.modalPresentationStyle = .fullScreen
		present(nav, animated: true)
	}
    
    func setupCollection() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(cellsPerRow: 2, heightRatio: 1, inset: 9, usesHorizontalScroll: true))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 150, left: 0, bottom: 0, right: 0)
        collectionView.register(SocialMediaCell.self, forCellWithReuseIdentifier: "id")
        collectionView.register(MainCollectionReusableView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "hId")
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "hId", for: indexPath) as! MainCollectionReusableView
        view.associatedHeaderIndex = indexPath.section
        view.showsTrailingButton = false
        view.title = "Social Media"
        return view
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath)
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
