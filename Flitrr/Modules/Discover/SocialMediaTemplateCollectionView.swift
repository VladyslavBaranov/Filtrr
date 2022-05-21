//
//  SocialMediaTemplateCollectionView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.05.2022.
//

import UIKit

struct DiscoverTemplateItem {
    var imageName: String
    var color: UIColor
    var title: String
    var size: CGSize = .zero
}

final class SocialMediaCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        backgroundColor = UIColor(red: 0, green: 0.511, blue: 1, alpha: 1)
        
        imageView = UIImageView(image: UIImage(named: "twitter"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        label = UILabel()
        label.text = "Instagram Story"
        label.numberOfLines = 0
        label.font = Montserrat.medium(size: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    func set(_ item: DiscoverTemplateItem) {
        imageView.image = UIImage(named: item.imageName)
        label.text = item.title
        backgroundColor = item.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
