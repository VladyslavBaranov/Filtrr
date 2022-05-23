//
//  GridView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.05.2022.
//

import UIKit

final class GridView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let count = UIDevice.current.userInterfaceIdiom == .pad ? 45 : 23
        
        let dimension: CGFloat = rect.width / CGFloat(count)
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var i = 0
        while y <= rect.height {
            for _ in 0..<count {
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
                i += 1
            }
        }
    }
    
}
