//
//  LayersCollectionView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 15.05.2022.
//

import UIKit

protocol LayersCollectionViewDelegate: AnyObject {
    func didSelect(_ filter: Filter)
}

final class LayersCollectionView: UICollectionView {
    
    private var selectedRow: Int = 0
    weak var filteringDelegate: LayersCollectionViewDelegate!
    
    var filters: [Filter] = [] {
        didSet {
            reloadData()
        }
    }
    
    var targetImage: UIImage!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .clear
        delegate = self
        dataSource = self
        contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        showsHorizontalScrollIndicator = false
        register(FiltersCollectionViewCell.self, forCellWithReuseIdentifier: "id")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LayersCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! FiltersCollectionViewCell
        let filter = filters[indexPath.row]
        cell.titleLabel.text = filter.displayName
        
        if indexPath.row == selectedRow {
            cell.setSelected()
        } else {
            cell.setUnselected()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filteringDelegate?.didSelect(filters[indexPath.row])
        selectedRow = indexPath.row
        for cell in collectionView.visibleCells {
            (cell as? FiltersCollectionViewCell)?.setUnselected()
        }
        (collectionView.cellForItem(at: indexPath) as? FiltersCollectionViewCell)?.setSelected()
    }
}

extension LayersCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width / 4, height: collectionView.bounds.height)
    }
}


