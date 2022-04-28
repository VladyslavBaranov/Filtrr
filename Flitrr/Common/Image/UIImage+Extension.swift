//
//  UIImage+Extension.swift
//  Flitrr
//
//  Created by VladyslavMac on 26.04.2022.
//

import UIKit

extension UIImage {
	func applyingFilter(name: String, parameters: [String: Any]) -> UIImage? {
		guard let ciImage = CIImage(image: self) else { return nil }
		let outputCIImage = ciImage.applyingFilter(name, parameters: parameters)
		let ctx = CIContext()
		ctx.createCGImage(outputCIImage, from: ciImage.extent)
		return UIImage(ciImage: outputCIImage)
	}
}
