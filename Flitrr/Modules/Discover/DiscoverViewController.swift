//
//  ViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.04.2022.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    private let templates: [DiscoverTemplateItem] = [
        .init(
            imageName: "Video",
            color: UIColor(red: 1, green: 0.02, blue: 0.4, alpha: 1),
            title: "Instagram Post 1080 x 1080",
            size: .init(width: 1080, height: 1080)
        ),
        .init(
            imageName: "Video",
            color: UIColor(red: 1, green: 0.02, blue: 0.4, alpha: 1),
            title: "Instagram Story 1920 x 1080",
            size: .init(width: 1080, height: 1920)
        ),
        .init(
            imageName: "Facebook",
            color: UIColor(red: 0, green: 0.511, blue: 1, alpha: 1),
            title: "Facebook Post 1200 x 630",
            size: .init(width: 630, height: 1200)
        ),
        .init(
            imageName: "twitter",
            color: UIColor(red: 0, green: 0.511, blue: 1, alpha: 1),
            title: "Twitter Post 1500 x 500",
            size: .init(width: 500, height: 1500)
        )
    ]
    
    lazy var searchResult: [DiscoverTemplateItem] = self.templates

    private var gradientLayer: CAGradientLayer!
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
        setupGradient()
        setupTopViews()
    }
    
    func setupGradient() {
        gradientLayer = CAGradientLayer()
        let whiteComponent: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0 : 1
        gradientLayer.colors = [
            UIColor(white: whiteComponent, alpha: 0.6).cgColor,
            UIColor(white: whiteComponent, alpha: 0.3).cgColor,
            UIColor(white: whiteComponent, alpha: 0).cgColor
        ]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.shouldRasterize = true
        gradientLayer.rasterizationScale = UIScreen.main.scale
        gradientLayer.startPoint = .init(x: 0.5, y: 0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = .init(x: 0, y: 0, width: view.bounds.width, height: view.safeAreaInsets.top + 80)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !paywallWasShown {
            if !StoreObserver.shared.isSubscribed() {
                paywallWasShown = true
                let controller = PaywallHostingController(rootView: PaywallView())
                if UIDevice.current.userInterfaceIdiom == .phone {
                    controller.modalPresentationStyle = .fullScreen
                }
                present(controller, animated: true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        }
    }
    
    func setupTopViews() {
        navigationView = NavigationView(frame: .zero)
        navigationView.title = LocalizationManager.shared.localizedString(for: .discoverTitle)
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
        searchTextField.returnKeyType = .done
        searchTextField.backgroundColor = .appDark
        searchTextField.placeholder = LocalizationManager.shared.localizedString(for: .discoverSearch)
        searchTextField.clearButtonMode = .whileEditing
        view.addSubview(searchTextField)
        searchTextField.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
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
        let rowsCount = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 4
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(cellsPerRow: rowsCount, heightRatio: 1, inset: 9, usesHorizontalScroll: false))
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
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResult.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "hId", for: indexPath) as! MainCollectionReusableView
        view.associatedHeaderIndex = indexPath.section
        view.showsTrailingButton = false
        view.title = LocalizationManager.shared.localizedString(for: .discoverCat)
        return view
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! SocialMediaCell
        cell.set(searchResult[indexPath.row])
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + view.safeAreaInsets.top + 160
        if offset > 0 {
            let fraction = 1 - offset / 160
            navigationView.alpha = fraction
            searchTextField?.alpha = fraction
        } else {
            navigationView.alpha = 1
            searchTextField?.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let projectCreatingVC = ProjectCreatingViewController()
        projectCreatingVC.targetImageSize = searchResult[indexPath.row].size
        projectCreatingVC.modalPresentationStyle = .fullScreen
        present(projectCreatingVC, animated: true)
    }
    
    @objc func searchTextFieldDidChange(_ sender: UISearchTextField) {
        guard let searchText = sender.text?.lowercased() else { return }
        if searchText.isEmpty {
            searchResult = templates
        } else {
            searchResult = templates.filter { $0.title.lowercased().contains(searchText) }
        }
        collectionView.reloadData()
    }
}

