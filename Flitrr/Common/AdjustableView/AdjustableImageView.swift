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
    var currentFilter: Filter! {
        didSet {
            if currentFilter.filterName.isEmpty {
                imageView.image = originalImage
            } else {
                imageView.image = originalImage.applyingFilter(
                    name: currentFilter.filterName,
                    parameters: [:]
                )
            }
        }
    }
    var originalImage: UIImage! {
        didSet {
            imageView.image = originalImage
        }
    }
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
    
    override func render(in ctx: CGContext) {
        ctx.move(to: frame.origin)
        // ctx.rotate(by: .pi / 4)
        // ctx.translateBy(x: -frame.origin.x, y: -frame.origin.y)
        imageView.image?.draw(in: frame, blendMode: .exclusion, alpha: 1)
    }
}
