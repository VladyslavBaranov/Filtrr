//
//  ScrollableRoundedBar.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 25.04.2022.
//

import UIKit

final class ScrollabelRoundedBarItemView: UICollectionViewCell {
    
    enum ItemType: String {
        case image, text, graphic, shape, filters, adjust, crop, shadow, opacity, background
    }
    
    var currentItem: ItemType = .image {
        didSet {
            imageView.image = .init(named: currentItem.rawValue.capitalized)
            label.text = currentItem.rawValue.uppercased()
        }
    }
    
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(image: .init(named: "Image"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        label = UILabel()
        label.textColor = .lightGray
        label.font = Montserrat.regular(size: 10)
        label.textAlignment = .center
        label.text = "IMAGE"
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ScrollableRoundedBarDelegate: AnyObject {
	func didTapItem(itemType: ScrollabelRoundedBarItemView.ItemType)
}

final class ScrollableRoundedBar: UIView {
    
    var items: [ScrollabelRoundedBarItemView.ItemType] = [
		.image, .text, .graphic, .shape, .background
    ]
    
	weak var delegate: ScrollableRoundedBarDelegate!
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appGray
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ScrollabelRoundedBarItemView.self, forCellWithReuseIdentifier: "id")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .appGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let roundedLayer = CAShapeLayer()
        roundedLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: .init(width: 15, height: 15)
        ).cgPath
        layer.mask = roundedLayer
        
    }
}

extension ScrollableRoundedBar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ScrollabelRoundedBarItemView
        cell.currentItem = items[indexPath.row]
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		delegate?.didTapItem(itemType: items[indexPath.row])
	}
}
extension ScrollableRoundedBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (collectionView.bounds.width - 20) / 4, height: collectionView.bounds.height)
    }
}
