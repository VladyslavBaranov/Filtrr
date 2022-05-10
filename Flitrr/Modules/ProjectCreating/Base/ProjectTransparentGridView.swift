//
//  ProjectTransparentGridView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.04.2022.
//

import UIKit

final class ProjectTransparentGridView: AdjustableView {
    
    enum BackgroundMode {
        case plainColor(UIColor)
        case image(UIImage)
    }
    
    var adjustables: [AdjustableView] = []
    
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
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        switch bakgroundMode {
        case .plainColor(let uIColor):
            if uIColor == .clear {
                let dimension: CGFloat = rect.width / 22.0
                var x: CGFloat = 0.0
                var y: CGFloat = 0.0
                
                while y <= rect.height {
                    for i in 0..<22 {
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
        }
        
    }
    
    var asPNG: Data? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let image = renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
        return image.pngData()
    }
    
    
}
