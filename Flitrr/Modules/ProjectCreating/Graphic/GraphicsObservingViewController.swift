//
//  GraphicsObservingViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 13.05.2022.
//

import UIKit

final class GraphicsObservingViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    var headerView: GraphicsStretchyHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        view.backgroundColor = .appDark
        
        headerView = GraphicsStretchyHeader(
            frame: .init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width * 0.6)
        )
        headerView.delegate = self
        view.addSubview(headerView)
    }
    
    func setupCollection() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout(cellsPerRow: 2, heightRatio: 1, inset: 9, usesHorizontalScroll: false)
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
        6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ProjectsImageCell
        cell.backgroundColor = .appGray
        cell.imageInset = 10
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
    }
}

extension GraphicsObservingViewController: GraphicsStretchyHeaderDelegate {
    func didTapBackButton() {
        dismiss(animated: true)
    }
}
