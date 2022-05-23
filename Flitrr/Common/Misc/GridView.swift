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
        
        let hCount = Int(rect.height / dimension)
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        for j in 0..<hCount {
            for i in 0..<count {
                ctx.addRect(.init(x: x, y: y, width: dimension, height: dimension))
                if i % 2 == 0 {
                    ctx.setFillColor(j % 2 == 0 ? UIColor.appGray.cgColor : UIColor.appDark.cgColor)
                } else {
                    ctx.setFillColor(j % 2 == 0 ? UIColor.appDark.cgColor : UIColor.appGray.cgColor)
                }
                ctx.fillPath()
                x += dimension
            }
            x = 0
            y += dimension
        }
    }
    
}
