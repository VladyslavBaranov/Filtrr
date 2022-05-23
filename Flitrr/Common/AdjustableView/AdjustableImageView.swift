//
//  AdjustableImageView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 08.05.2022.
//

import UIKit

protocol AdjustableImageViewDelegate: AnyObject {
    func didToggleFilterMode(_ view: AdjustableImageView)
    func didUpdateImage(_ view: AdjustableImageView, _ newImage: UIImage)
}

enum CropCategory {
    case original, square, circle, p3x4, p4x3
}

final class AdjustableImageView: AdjustableView {
    
    var cropCategory = CropCategory.original
    var imageDelegate: AdjustableImageViewDelegate!
    
    var lastCI: CIImage!
    var filters: [Filter] = []
    func add(_ filter: Filter) {
        filters.append(filter)
        if lastCI == nil {
            lastCI = originalImage.applyingFilterCI(name: filter.filterName, parameters: [:])
        } else {
            lastCI = lastCI.applyingFilter(filter.filterName, parameters: [:])
        }
        if lastCI != nil {
            imageDelegate?.didUpdateImage(self, UIImage(ciImage: lastCI))
            // imageView.image = UIImage(ciImage: lastCI)
        }
    }
    
    func applyToCI(name: String, paramaters: [String: Any]) {
        if let lastCI = lastCI {
            let newCI = lastCI.applyingFilter(name, parameters: paramaters)
            imageDelegate?.didUpdateImage(self, UIImage(ciImage: newCI))
            // imageView.image = UIImage(ciImage: newCI)
        } else {
            if let newCI = originalImage.applyingFilter(name: name, parameters: paramaters) {
                imageDelegate?.didUpdateImage(self, newCI)
                // imageView.image = newCI
            }
        }
    }
    
    func removeAllFilters() {
        filters.removeAll()
        lastCI = nil
        imageView.image = originalImage
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
    
    func applyFilter(_ filterName: String, parameters: [String: Any]) {
        guard let image = originalImage.applyingFilter(
            name: filterName, parameters: parameters) else { return }
        imageDelegate?.didUpdateImage(self, image)
        // imageView.image = originalImage.applyingFilter(name: filterName, parameters: parameters)
    }
}
