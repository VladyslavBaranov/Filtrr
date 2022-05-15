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
   
        var blendMode = CGBlendMode.normal
        if let str = layer.compositingFilter as? String {
            switch str {
            case "normalBlendMode":
                blendMode = .normal
            case "dakenBlendMode":
                blendMode = .darken
            case "multiplyBlendMode":
                blendMode = .multiply
            case "colorBurnBlendMode":
                blendMode = .colorBurn
            case "lightenBlendMode":
                blendMode = .lighten
            case "differenceBlendMode":
                blendMode = .difference
            case "exclusionBlendMode":
                blendMode = .exclusion
            case "xorBlendMode":
                blendMode = .xor
            default:
                break
            }
        }
        // ctx.rotate(by: .pi / 4)
        // ctx.translateBy(x: -frame.origin.x, y: -frame.origin.y)
        imageView.image?.draw(in: frame, blendMode: blendMode, alpha: 1)
    }
}
