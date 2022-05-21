//
//  ProjectTransparentGridView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.04.2022.
//

import UIKit

final class ProjectTransparentGridView: AdjustableView {
    
    var targetImageSize: CGSize = .init(width: 1080, height: 1080)
    
    enum BackgroundMode {
        case plainColor(UIColor)
        case image(UIImage)
        case gradient([UIColor])
    }
    
    var adjustables: [AdjustableView] = []
    var trashButton: UIButton!
    
    var bakgroundMode = BackgroundMode.plainColor(.clear) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func add(_ adjustable: AdjustableView) {
        adjustables.append(adjustable)
        addSubview(adjustable)
        setNeedsDisplay()
    }
    
    func remove(_ adjustable: AdjustableView) {
        adjustable.removeFromSuperview()
        adjustables.removeAll { $0.id == adjustable.id }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        trashButton = UIButton()
        trashButton.setImage(UIImage(systemName: "trash"), for: .normal)
        trashButton.frame.size = .init(width: 40, height: 40)
        trashButton.layer.cornerRadius = 20
        trashButton.layer.cornerCurve = .continuous
        trashButton.tintColor = .white
        trashButton.backgroundColor = UIColor.systemGray5
        trashButton.addTarget(self, action: #selector(handleTrash), for: .touchUpInside)
        addSubview(trashButton)
        hideTrash()
    }
    
    @objc func handleTrash() {
        for adjustable in adjustables {
            if adjustable.gridIsActive {
                adjustable.removeFromSuperview()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trashButton.center = .init(x: bounds.midX, y: bounds.height - 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        switch bakgroundMode {
        case .plainColor(let uIColor):
            
            
            let count = UIDevice.current.userInterfaceIdiom == .pad ? 45 : 22
            if uIColor == .clear {
                let dimension: CGFloat = rect.width / CGFloat(count)
                var x: CGFloat = 0.0
                var y: CGFloat = 0.0
                
                while y <= rect.height {
                    for i in 0..<count {
                        ctx.addRect(.init(x: x, y: y, width: dimension, height: dimension))
                        if i % 2 == 0 {
                            ctx.setFillColor(UIColor.appGray.cgColor)
                        } else {
                            ctx.setFillColor(UIColor.appDark.cgColor)
                        }
                        ctx.fillPath()
                        x += dimension
                        if x >= rect.width {
                            x = 0
                            y += dimension
                        }
                    }
                }
            } else {
                uIColor.setFill()
                UIRectFill(bounds)
            }
        case .image(let uIImage):
            uIImage.draw(in: bounds)
        case .gradient(let colors):
            let cgColors = colors.map { $0.cgColor }
            guard let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: cgColors as CFArray, locations: nil) else { return }
            ctx.drawLinearGradient(
                gradient,
                start: .zero, end: .init(x: rect.width, y: rect.height),
                options: []
            )
        }
        
    }
    
    func createPNG() -> Data? {
        
        let xFactor = targetImageSize.width / bounds.width
        let yFactor = targetImageSize.height / bounds.height
        
        UIGraphicsBeginImageContext(targetImageSize)
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        
        switch bakgroundMode {
        case .plainColor(let uIColor):
            
            ctx.setFillColor(uIColor.cgColor)
            ctx.fill(.init(origin: .zero, size: targetImageSize))
            
            for adjustable in adjustables {
                adjustable.render(in: ctx, factor: .init(x: xFactor, y: yFactor))
            }
            
        default:
            layer.render(in: ctx)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        
        return image?.pngData()
    }
    
    func hideTrash() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            trashButton.alpha = 0
        } completion: { [unowned self] _ in
            trashButton.isHidden = true
        }
    }
    
    func showTrash() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            trashButton.alpha = 1
        } completion: { [unowned self] _ in
            trashButton.isHidden = false
        }
    }
}
