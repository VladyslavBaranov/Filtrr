//
//  ShapesViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 10.05.2022.
//

import UIKit

final class ShapesViewController: UIViewController {
    
    private var navigationView: NavigationView!
    var searchTextField: UISearchTextField!
    private var shapeCategoryPicker: ValuePickerView!
    var collectionView: UICollectionView!
    
    private let images = [
        "BlueStar5", "BlueStar5Round", "BlueStar6",
        "Ocean3", "Ocean3Round", "Ocean4",
        "Purple6", "Purple6Round", "PurpleRhombus"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupTopViews()
        view.backgroundColor = .appDark
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shapeCategoryPicker.frame = .init(x: 0, y: view.safeAreaInsets.top + 130, width: view.bounds.width, height: 80)
    }
    
    func setupTopViews() {
        navigationView = NavigationView(frame: .zero)
        navigationView.hidesSettingsButton = true
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.title = "Shapes"
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.heightAnchor.constraint(equalToConstant: 80),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        searchTextField = UISearchTextField()
        searchTextField.backgroundColor = .appDark
        searchTextField.placeholder = "Search Shapes"
        searchTextField.clearButtonMode = .whileEditing
        view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            searchTextField.topAnchor.constraint(equalTo: navigationView.bottomAnchor)
        ])
        setupShapePicker()
    }
    
    func setupShapePicker() {
        shapeCategoryPicker = ValuePickerView(
            frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
        shapeCategoryPicker.titles = ["Basic", "Holiday", "Outline", "Bursh"]
        shapeCategoryPicker.isTransparentAppearance = true
        shapeCategoryPicker.leftInset = 13
        shapeCategoryPicker.itemHeight = 40
        shapeCategoryPicker.pickerStyle = .style2
        view.addSubview(shapeCategoryPicker)
    }
    
    func setupCollection() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(cellsPerRow: 3, heightRatio: 1, inset: 9))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 162, left: 0, bottom: 0, right: 0)
        collectionView.register(ProjectsImageCell.self, forCellWithReuseIdentifier: "id")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

extension ShapesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ProjectsImageCell
        cell.imageView.image = UIImage(named: images[indexPath.row])
        cell.backgroundColor = .appGray
        cell.imageInset = 10
        cell.layer.cornerRadius = 10
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + view.safeAreaInsets.top + 162
        if offset > 0 {
            let fraction = 1 - offset / 80
            navigationView.alpha = fraction
            searchTextField?.alpha = fraction
            
            let pickerFraction = 1 - offset / 40
            shapeCategoryPicker.alpha = pickerFraction
        } else {
            navigationView.alpha = 1
            searchTextField?.alpha = 1
            shapeCategoryPicker.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true)
    }
}
