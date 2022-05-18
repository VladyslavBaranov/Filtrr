//
//  SocialMediaTemplateCollectionView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.05.2022.
//

import UIKit

final class SocialMediaCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        backgroundColor = UIColor(red: 0, green: 0.511, blue: 1, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
