//
//  FiltersCollectionView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 09.05.2022.
//

import UIKit

protocol FiltersCollectionViewDelegate: AnyObject {
    func didSelect(_ filter: Filter)
}

final class FiltersCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    func setSelected() {
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.appAccent.cgColor
        imageView.alpha = 0.7
        titleLabel.textColor = .appAccent
    }
    
    func setUnselected() {
        imageView.layer.borderWidth = 0
        imageView.alpha = 1
        titleLabel.textColor = .label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        titleLabel = UILabel()
        titleLabel.text = "LAYER 1"
        titleLabel.textAlignment = .center
        titleLabel.font = Montserrat.regular(size: 10)
        addSubview(titleLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.height - 30)
        titleLabel.frame = .init(x: 0, y: bounds.height - 30, width: bounds.width, height: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class FiltersCollectionView: UICollectionView {
    
    weak var filteringDelegate: FiltersCollectionViewDelegate!
    let filteringQueue = DispatchQueue(label: "com.filtrr.filtering")
    
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

extension FiltersCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! FiltersCollectionViewCell
        let filter = filters[indexPath.row]
        cell.titleLabel.text = filter.displayName
        
        if indexPath.row == 0 {
            cell.imageView.image = targetImage
        } else {
            filteringQueue.async { [unowned self] in
                let img = targetImage.applyingFilter(name: filter.filterName, parameters: [:])
                DispatchQueue.main.async {
                    cell.imageView.image = img
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filteringDelegate?.didSelect(filters[indexPath.row])
        (collectionView.cellForItem(at: indexPath) as? FiltersCollectionViewCell)?.setSelected()
    }
}

extension FiltersCollectionView: UICollectionViewDelegateFlowLayout {
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

