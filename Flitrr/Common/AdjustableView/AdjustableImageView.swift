//
//  AdjustableImageView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 08.05.2022.
//

import UIKit

protocol AdjustableImageViewDelegate: AnyObject {
    func didToggleFilterMode(_ view: AdjustableImageView)
}

final class AdjustableImageView: AdjustableView {
    
    var imageDelegate: AdjustableImageViewDelegate!
    var originalImage: UIImage!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleToFill
        insertSubview(imageView, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}
