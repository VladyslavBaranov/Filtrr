//
//  AlphaView.swift
//  Flitrr
//
//  Created by VladyslavMac on 28.04.2022.
//

import UIKit

final class AlphaView: UIView {
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		guard let ctx = UIGraphicsGetCurrentContext() else { return }
		
		let dimension: CGFloat = rect.height / 3
		var x: CGFloat = 0.0
		var y: CGFloat = 0.0
		var i = 0
	
		while y <= rect.height {
			
			while x <= rect.width {
				ctx.addRect(.init(x: x, y: y, width: dimension, height: dimension))
				if i % 2 == 0 {
					ctx.setFillColor(UIColor.appGray.cgColor)
				} else {
					ctx.setFillColor(UIColor.appDark.cgColor)
				}
				ctx.fillPath()
				x += dimension
				if x >= rect.width {
					y += dimension
					x = 0
					break
				}
				
				i += 1
			}
		}
	}
}
