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

enum CropCategory {
    case original, square, circle, p3x4, p4x3
}

final class AdjustableImageView: AdjustableView {
    
    var cropCategory = CropCategory.original
    
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
    
    var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleToFill
        insertSubview(imageView, at: 0)
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        activityIndicator.center = .init(x: bounds.midX, y: bounds.midY)
    }
    
    override func render(in ctx: CGContext, factor: CGPoint) {
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
        let frame = CGRect(
            x: frame.origin.x * factor.x,
            y: frame.origin.y * factor.y,
            width: frame.width * factor.x,
            height: frame.height * factor.y)
        imageView.image?.draw(in: frame, blendMode: blendMode, alpha: 1)
    }
}
