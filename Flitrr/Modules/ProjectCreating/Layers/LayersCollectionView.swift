//
//  LayersCollectionView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 15.05.2022.
//

import UIKit

protocol LayersCollectionViewDelegate: AnyObject {
    func didSelect(_ adjustable: AdjustableView)
}

final class LayersCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var label: UILabel!
    
    var titleLabel: UILabel!
    
    var adjustable: AdjustableView!
    
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
    
    func set(_ adjustable: AdjustableView) {
        if adjustable is AdjustableImageView {
            imageView.isHidden = false
            label.isHidden = true
            imageView.image = (adjustable as! AdjustableImageView).originalImage
        }
        if adjustable is AdjustableLabel {
            imageView.isHidden = true
            label.isHidden = false
            label.textAlignment = .center
            label.text = (adjustable as! AdjustableLabel).label.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        titleLabel = UILabel()
        titleLabel.text = "\(LocalizationManager.shared.localizedString(for: .layersUL)) 1"
        titleLabel.textAlignment = .center
        titleLabel.font = Montserrat.regular(size: 10)
        addSubview(titleLabel)
        
        label = UILabel()
        label.numberOfLines = 0
        label.font = Montserrat.medium(size: 16)
        label.textColor = .label
        addSubview(label)
        label.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.height - 30)
        titleLabel.frame = .init(x: 0, y: bounds.height - 30, width: bounds.width, height: 30)
        label.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.height - 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class LayersCollectionView: UICollectionView {
    
    private var selectedRow: Int = 0
    weak var layersDelegate: LayersCollectionViewDelegate!
    
    var layers: [AdjustableView] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .clear
        delegate = self
        dataSource = self
        contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        showsHorizontalScrollIndicator = false
        register(LayersCollectionViewCell.self, forCellWithReuseIdentifier: "id")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LayersCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        layers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! LayersCollectionViewCell
        cell.set(layers[indexPath.row])
        cell.titleLabel.text = "LAYER \(indexPath.row + 1)"
        
        if indexPath.row == selectedRow {
            cell.setSelected()
        } else {
            cell.setUnselected()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        for cell in collectionView.visibleCells {
            (cell as? LayersCollectionViewCell)?.setUnselected()
        }
        (collectionView.cellForItem(at: indexPath) as? LayersCollectionViewCell)?.setSelected()
        layersDelegate?.didSelect(layers[indexPath.row])
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


