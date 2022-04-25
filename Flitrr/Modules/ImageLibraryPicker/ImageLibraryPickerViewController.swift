//
//  ImageLibraryPickerViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 25.04.2022.
//

import UIKit
import Photos

final class ImageCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        addSubview(imageView)
        
        imageView.frame = bounds
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(phAsset: PHAsset) {
        let options = PHImageRequestOptions()
        PHImageManager.default().requestImage(
            for: phAsset,
            targetSize: .init(width: 500, height: 500),
            contentMode: .aspectFill,
            options: options) { [weak self] image, _ in
                if let image = image {
                    self?.imageView.image = image
                }
            }
    }
    
    func set(contentMode: ContentMode) {
        imageView.contentMode = contentMode
    }
}

final class ImageLibraryPickerViewController: UIViewController {
    
    var allPhotos: PHFetchResult<PHAsset>?
    
    var photosContentMode: UIView.ContentMode = .scaleAspectFill
    
    var closeButton: UIButton!
    var prefsButton: UIButton!
    private var gradientLayer: CAGradientLayer!

    var collectionView: UICollectionView!
    var collectionsCollectionView: HorizontalCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appDark
        setupMainCollectionView()
        
        setupGradient()
        setupButtons()
        loadAssets()
        
        setupCollectionsCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = .init(x: 0, y: 0, width: view.bounds.width, height: view.safeAreaInsets.top + 90)
        collectionView.contentInset = .init(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + 120, right: 0)
    }
    
    func loadAssets() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                let fetchedAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                self?.allPhotos = fetchedAssets
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.collectionView.scrollToItem(
                        at: .init(row: fetchedAssets.count - 1, section: 0), at: .bottom, animated: false)
                }
                
            default:
                break
            }
        }
    }
    
    func setupGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 0, alpha: 0.8).cgColor,
            UIColor(white: 0, alpha: 0.4).cgColor,
            UIColor(white: 0, alpha: 0).cgColor
        ]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.shouldRasterize = true
        gradientLayer.rasterizationScale = UIScreen.main.scale
        gradientLayer.startPoint = .init(x: 0.5, y: 0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1)
    }

    func createMenu(title: String, imageName: String) -> UIMenu {
        
        let action = UIAction(
            title: title,
            image: UIImage(systemName: imageName)
        ) { [unowned self] _ in
            if photosContentMode == .scaleAspectFit {
                photosContentMode = .scaleAspectFill
            } else {
                photosContentMode = .scaleAspectFit
            }
            let visibleCells = collectionView.visibleCells as! [ImageCollectionViewCell]
            for visibleCell in visibleCells {
                visibleCell.set(contentMode: photosContentMode)
            }
            
            let title1 = photosContentMode == .scaleAspectFit ? "Square" : "Aspect"
            let imageName1 = photosContentMode == .scaleAspectFit ? "rectangle.arrowtriangle.2.outward" : "rectangle.arrowtriangle.2.inward"
            navigationItem.rightBarButtonItem?.menu = createMenu(title: title1, imageName: imageName1)
        }
        let addNewMenu = UIMenu(
            title: "",
            children: [action])
        
        return addNewMenu
    }
    
    func setupMainCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout(cellsPerRow: 3, heightRatio: 1, inset: 1)
        )
        
        collectionView.backgroundColor = .appDark
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "id")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
    }
    func setupCollectionsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionsCollectionView = HorizontalCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionsCollectionView)
        NSLayoutConstraint.activate([
            collectionsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionsCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self, action: #selector(dismissSelf))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "ellipsis.circle"),
            primaryAction: nil,
            menu: createMenu(title: "Aspect", imageName: "rectangle.arrowtriangle.2.inward")
        )
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func setupButtons() {
        closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        prefsButton = UIButton()
        prefsButton.setPreferredSymbolConfiguration(.init(pointSize: 28), forImageIn: .normal)
        prefsButton.setImage(.init(systemName: "ellipsis.circle"), for: .normal)
        prefsButton.tintColor = .white
        prefsButton.translatesAutoresizingMaskIntoConstraints = false
        prefsButton.menu = createMenu(title: "Aspect", imageName: "rectangle.arrowtriangle.2.inward")
        prefsButton.showsMenuAsPrimaryAction = true
        view.addSubview(prefsButton)
        
        NSLayoutConstraint.activate([
            prefsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            prefsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    static func createInstance() -> ImageLibraryPickerViewController {
        let controller = ImageLibraryPickerViewController()
        // let nav = UINavigationController(rootViewController: controller)
        return controller
    }
}

extension ImageLibraryPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allPhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.contentMode = photosContentMode
        if let allPhotos = allPhotos {
            if indexPath.row <= allPhotos.count {
                let asset = allPhotos[indexPath.row]
                cell.set(phAsset: asset)
            }
        }
        return cell
    }
}
