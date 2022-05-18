//
//  ProjectsImageCell.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 19.04.2022.
//

import UIKit

final class ProjectsImageCell: UICollectionViewCell {
    
    var layoutType = 0 {
        didSet {
            if layoutType == 0 {
                imageInset = 10
                imageView.contentMode = .scaleAspectFit
            } else if layoutType == 1 {
                imageInset = bounds.width / 4
                imageView.contentMode = .scaleAspectFit
            } else {
                imageInset = 0
                imageView.contentMode = .scaleAspectFill
            }
        }
    }
    
    var imageView: UIImageView!
    var imageInset: CGFloat = 0.0 {
        didSet {
            //if imageInset != 0 {
            //    imageView.contentMode = .scaleAspectFit
            //}
            imageView.frame = bounds.insetBy(dx: imageInset, dy: imageInset)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: bounds)
        addSubview(imageView)
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
