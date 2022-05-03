//
//  UIColor.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.04.2022.
//

import UIKit

extension UIColor {
    static let soft2 = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
    static let appAccent = UIColor(red: 1, green: 0.02, blue: 0.4, alpha: 1)
    static let appDark = UIColor(red: 0.086, green: 0.09, blue: 0.094, alpha: 1)
    static let appGray = UIColor(red: 0.173, green: 0.173, blue: 0.18, alpha: 1)
	
	func hexString() -> String {
		let components = cgColor.components
		let r: CGFloat = components?[0] ?? 0.0
		let g: CGFloat = components?[1] ?? 0.0
		let b: CGFloat = components?[2] ?? 0.0
		
		let hexString = String(
			format: "#%02lX%02lX%02lX",
			lroundf(Float(r * 255)),
			lroundf(Float(g * 255)),
			lroundf(Float(b * 255))
		)
		return hexString
	}
}
