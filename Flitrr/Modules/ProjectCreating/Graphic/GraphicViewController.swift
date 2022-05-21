//
//  GraphicViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 11.05.2022.
//

import UIKit

protocol MainCollectionReusableViewDelegate: AnyObject {
    func didTapSeeAll()
}

final class MainCollectionReusableView: UICollectionReusableView {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
    
    var showsTrailingButton: Bool = true {
        didSet {
            seeAllButton.isHidden = !showsTrailingButton
            chevronView.isHidden = !showsTrailingButton
        }
    }
    var associatedHeaderIndex = 0
    
    private var titleLabel: UILabel!
    private var seeAllButton: UIButton!
    private var chevronView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
        titleLabel.text = "Latest Collections"
        titleLabel.font = Montserrat.medium(size: 17)
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        seeAllButton = UIButton()
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.setTitleColor(.gray, for: .normal)
        seeAllButton.titleLabel?.font = Montserrat.regular(size: 13)
        addSubview(seeAllButton)
        
        chevronView = UIImageView(image: .init(systemName: "chevron.right"))
        chevronView.contentMode = .scaleAspectFit
        chevronView.tintColor = .gray
        addSubview(chevronView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSeeAllAction() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = .init(x: 10, y: 0, width: titleLabel.frame.width, height: bounds.height)
        seeAllButton.frame = .init(x: bounds.width - 60, y: 0, width: 50, height: bounds.height)
        chevronView.frame = .init(x: bounds.width - 10, y: 0, width: 10, height: bounds.height)
    }
}

protocol GraphicViewControllerDelegate: AnyObject {
    func didSelectGraphic(_ uiImage: UIImage)
}
 
final class GraphicViewController: UIViewController {
    
    let loader = GraphicsLoader()
    
    weak var delegate: GraphicViewControllerDelegate!
    
    private var closeButton: UIButton!
    private var navigationView: NavigationView!
    var searchTextField: UISearchTextField!
    private var shapeCategoryPicker: ValuePickerView!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupTopViews()
        view.backgroundColor = .appDark
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = .init(top: navigationView.frame.maxY, left: 0, bottom: 0, right: 0)
        //shapeCategoryPicker.frame = .init(x: 0, y: view.safeAreaInsets.top + 130, width: view.bounds.width, height: 80)
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
        navigationView.title = "Graphics"
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.heightAnchor.constraint(equalToConstant: 80),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: closeButton.bottomAnchor)
        ])
        //
        // searchTextField = UISearchTextField()
        // searchTextField.backgroundColor = .appDark
        // searchTextField.placeholder = "Search Graphics"
        // searchTextField.clearButtonMode = .whileEditing
        // view.addSubview(searchTextField)
        // searchTextField.translatesAutoresizingMaskIntoConstraints = false
        // NSLayoutConstraint.activate([
        //     searchTextField.heightAnchor.constraint(equalToConstant: 50),
        //     searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
        //     searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        //     searchTextField.topAnchor.constraint(equalTo: navigationView.bottomAnchor)
        // ])
        // setupShapePicker()
    }
    
    func setupShapePicker() {
        shapeCategoryPicker = ValuePickerView(
            frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
        shapeCategoryPicker.titles = ["Pattern", "Floral", "Retro", "Abstract"]
        shapeCategoryPicker.isTransparentAppearance = true
        shapeCategoryPicker.leftInset = 13
        shapeCategoryPicker.itemHeight = 40
        shapeCategoryPicker.pickerStyle = .style2
        view.addSubview(shapeCategoryPicker)
    }
    
    func setupCollection() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout(cellsPerRow: 2, heightRatio: 1.2, inset: 9, usesHorizontalScroll: true)
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 232, left: 0, bottom: 0, right: 0)
        collectionView.register(ProjectsFolderCell.self, forCellWithReuseIdentifier: "id")
        collectionView.register(MainCollectionReusableView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "hId")
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

extension GraphicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        loader.collections.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "hId", for: indexPath) as! MainCollectionReusableView
        view.associatedHeaderIndex = indexPath.section
        return view
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ProjectsFolderCell
        let collection = loader.collections[indexPath.row]
        cell.imageView.image = UIImage(named: collection.thumb)
        cell.folderCountLabel.text = "\(collection.numberOfPics)"
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + navigationView.frame.maxY
        if offset > 0 {
            let fraction = 1 - offset / 80
            navigationView.alpha = fraction
            // searchTextField?.alpha = fraction
            
            //let pickerFraction = 1 - offset / 40
            // shapeCategoryPicker.alpha = pickerFraction
        } else {
            navigationView.alpha = 1
            // searchTextField?.alpha = 1
            // shapeCategoryPicker.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let observingVC = GraphicsObservingViewController()
        observingVC.delegate = self
        observingVC.collection = loader.collections[indexPath.row]
        observingVC.modalPresentationStyle = .fullScreen
        observingVC.overrideUserInterfaceStyle = .dark
        present(observingVC, animated: true)
    }
}

extension GraphicViewController: GraphicsObservingViewControllerDelegate {
    func didSelect(_ uiImage: UIImage?) {
        if let uiImage = uiImage {
            delegate?.didSelectGraphic(uiImage)
        }
        dismiss(animated: true)
    }
}
