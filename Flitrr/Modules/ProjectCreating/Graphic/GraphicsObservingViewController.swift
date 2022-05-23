//
//  GraphicsObservingViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 13.05.2022.
//

import UIKit

protocol GraphicsObservingViewControllerDelegate: AnyObject {
    func didSelect(_ uiImage: UIImage?)
}

final class GraphicsObservingViewController: UIViewController {
    
    weak var delegate: GraphicsObservingViewControllerDelegate!
    var collection: GraphicsCollection!
    
    private var collectionView: UICollectionView!
    
    private var headerView: GraphicsStretchyHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        view.backgroundColor = .appDark
        
        headerView = GraphicsStretchyHeader(
            frame: .init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width * 0.6)
        )
        headerView.defaultHeight = view.bounds.width * 0.6
        headerView.imageView.image = UIImage(named: collection.header)
        headerView.title = collection.title
        headerView.countLabel.text = "\(collection.numberOfPics) graphics"
        headerView.delegate = self
        view.addSubview(headerView)
    }
    
    func setupCollection() {
        let rows = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout(cellsPerRow: rows, heightRatio: 1.3, inset: 9, usesHorizontalScroll: false)
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(
            top: view.bounds.width * 0.6, left: 0, bottom: 0, right: 0)
        collectionView.register(ProjectsImageCell.self, forCellWithReuseIdentifier: "id")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

extension GraphicsObservingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collection.content.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ProjectsImageCell
        cell.backgroundColor = .appGray
        cell.imageView.image = UIImage(
            named: collection.content[indexPath.row].image)
        cell.layoutType = collection.content[indexPath.row].layoutType
        cell.layer.cornerRadius = 10
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + view.safeAreaInsets.top + view.bounds.width * 0.6
        if offset < 0 {
            headerView.frame.size.height = abs(offset) + view.safeAreaInsets.top + view.bounds.width * 0.6
        } else {
            headerView.frame.origin.y = -offset
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didSelect(UIImage(
                named: strongSelf.collection.content[indexPath.row].image))
        }
    }
}

extension GraphicsObservingViewController: GraphicsStretchyHeaderDelegate {
    func didTapBackButton() {
        dismiss(animated: true)
    }
}
