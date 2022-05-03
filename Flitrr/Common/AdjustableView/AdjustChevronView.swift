//
//  AdjustChevronView.swift
//  Flitrr
//
//  Created by VladyslavMac on 26.04.2022.
//

import UIKit

final class AdjustChevronView: UIView {
	
	enum Corner {
		case uLeft, uRight, lLeft, lRight
	}
	
	var corner: Corner = .lLeft
	
	init(frame: CGRect, corner: Corner) {
		super.init(frame: frame)
		self.corner = corner
		backgroundColor = .clear
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		guard let ctx = UIGraphicsGetCurrentContext() else { return }
		
		let path = CGMutablePath()
		
		switch corner {
		case .uLeft:
			ctx.move(to: .init(x: 0, y: bounds.height))
			ctx.addLine(to: .zero)
			ctx.addLine(to: .init(x: bounds.width, y: 0))
		case .uRight:
			ctx.move(to: .init(x: 0, y: 0))
			ctx.addLine(to: .init(x: bounds.width, y: 0))
			ctx.addLine(to: .init(x: bounds.width, y: bounds.height))
		case .lLeft:
			ctx.move(to: .init(x: 0, y: 0))
			ctx.addLine(to: .init(x: 0, y: bounds.height))
			ctx.addLine(to: .init(x: bounds.width, y: bounds.height))
		case .lRight:
			ctx.move(to: .init(x: bounds.width, y: 0))
			ctx.addLine(to: .init(x: bounds.width, y: bounds.height))
			ctx.addLine(to: .init(x: 0, y: bounds.height))
		}
		
		ctx.addPath(path)
		ctx.setStrokeColor(UIColor.white.cgColor)
		ctx.setLineWidth(4)
	
		ctx.strokePath()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
