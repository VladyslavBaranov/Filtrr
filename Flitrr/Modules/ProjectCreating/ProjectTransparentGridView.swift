//
//  ProjectTransparentGridView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.04.2022.
//

import UIKit

final class ProjectTransparentGridView: UIView {
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
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
        
    }
}
