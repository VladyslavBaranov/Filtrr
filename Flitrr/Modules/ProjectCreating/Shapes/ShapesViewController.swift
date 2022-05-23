//
//  ShapesViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 10.05.2022.
//

import UIKit

protocol ShapesViewControllerDelegate: AnyObject {
    func didSelectBasicShape(_ name: String, size: CGSize)
}

final class ShapesViewController: UIViewController {
    
    weak var delegate: ShapesViewControllerDelegate!
    
    private var closeButton: UIButton!
    private var navigationView: NavigationView!
    // var searchTextField: UISearchTextField!
    private var shapeCategoryPicker: ValuePickerView!
    var collectionView: UICollectionView!
    
    var selectedIndex = 0
    private let images: [[String]] = [
        [
            "BlueStar5", "BlueStar5Round", "BlueStar6",
            "Ocean3", "Ocean3Round", "Ocean4",
            "Purple6", "Purple6Round", "PurpleRhombus",
            "Magenta8", "Magenta8Round", "MagentaHeart",
            "RedHeart1", "RedHeart2", "RedHeart3"
        ],
        [
            "BlueStar5O", "BlueStar5RoundO", "BlueStar6O",
            "Ocean3O", "Ocean3RoundO", "Ocean4O",
            "Purple6O", "Purple6RoundO", "PurpleRhombusO",
            "Magenta8O", "Magenta8RoundO", "MagentaHeartO",
            "RedHeart1O", "RedHeart2O", "RedHeart3O"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupTopViews()
        view.backgroundColor = .appDark
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shapeCategoryPicker.frame = .init(
            x: 0,
            y: view.safeAreaInsets.top + closeButton.frame.height + 80, width: view.bounds.width, height: 80)
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    func setupTopViews() {
        
        closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        navigationView = NavigationView(frame: .zero)
        navigationView.hidesSettingsButton = true
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.title = LocalizationManager.shared.localizedString(for: .shapesTitle)
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.heightAnchor.constraint(equalToConstant: 80),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: closeButton.bottomAnchor)
        ])
        
        // searchTextField = UISearchTextField()
        // searchTextField.backgroundColor = .appDark
        // searchTextField.placeholder = LocalizationManager.shared.localizedString(for: .shapesSearch)
        // searchTextField.clearButtonMode = .whileEditing
        // view.addSubview(searchTextField)
        // searchTextField.translatesAutoresizingMaskIntoConstraints = false
        // NSLayoutConstraint.activate([
        //     searchTextField.heightAnchor.constraint(equalToConstant: 50),
        //     searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
        //     searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        //     searchTextField.topAnchor.constraint(equalTo: navigationView.bottomAnchor)
        // ])
        setupShapePicker()
    }
    
    func setupShapePicker() {
        shapeCategoryPicker = ValuePickerView(
            frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
        shapeCategoryPicker.titles = [
            LocalizationManager.shared.localizedString(for: .shapesBasic),
            LocalizationManager.shared.localizedString(for: .shapesOutline)
        ]
        shapeCategoryPicker.delegate = self
        shapeCategoryPicker.isTransparentAppearance = true
        shapeCategoryPicker.leftInset = 13
        shapeCategoryPicker.itemHeight = 40
        shapeCategoryPicker.pickerStyle = .style2
        view.addSubview(shapeCategoryPicker)
    }
    
    func setupCollection() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout(cellsPerRow: 3, heightRatio: 1, inset: 9, usesHorizontalScroll: false)
        )
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
        images[selectedIndex].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ProjectsImageCell
        cell.imageView.image = UIImage(named: images[selectedIndex][indexPath.row])
        cell.backgroundColor = .appGray
        cell.imageInset = 10
        cell.layer.cornerRadius = 10
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + view.safeAreaInsets.top + 182
        if offset > 0 {
            let fraction = 1 - offset / 80
            navigationView.alpha = fraction
            // searchTextField?.alpha = fraction
            
            let pickerFraction = 1 - offset / 40
            shapeCategoryPicker.alpha = pickerFraction
        } else {
            navigationView.alpha = 1
            // searchTextField?.alpha = 1
            shapeCategoryPicker.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        delegate?.didSelectBasicShape(images[selectedIndex][indexPath.row], size: cell.frame.size)
        dismiss(animated: true)
    }
}

extension ShapesViewController: ValuePickerViewDelegate {
    func didSelectValue(at index: Int) {
        selectedIndex = index
        collectionView.reloadData()
    }
}
