//
//  UIImage+Extension.swift
//  Flitrr
//
//  Created by VladyslavMac on 26.04.2022.
//

import UIKit
import BackgroundRemoval

extension UIImage {
    
    func applyingFilterCI(name: String, parameters: [String: Any]) -> CIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        return ciImage.applyingFilter(name, parameters: parameters)
    }
    
	func applyingFilter(name: String, parameters: [String: Any]) -> UIImage? {
		guard let ciImage = CIImage(image: self) else { return nil }
		let outputCIImage = ciImage.applyingFilter(name, parameters: parameters)
		return UIImage(ciImage: outputCIImage)
	}
    
    func circleCut() -> UIImage {
        let minSize = min(size.width, size.height)
        let ovalX = size.width < size.height ? 0 : (size.width - size.height) / 2
        let ovalY = size.width < size.height ? (size.height - size.width) / 2 : 0
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let path = UIBezierPath(
                ovalIn: .init(
                    x: ovalX, y: ovalY, width: minSize, height: minSize
                )
            )
            
            path.addClip()
            draw(in: .init(origin: .zero, size: size))
        }
    }
    
    func squareCut() -> UIImage {
        let minSize = min(size.width, size.height)
        let ovalX = size.width < size.height ? 0 : (size.width - size.height) / 2
        let ovalY = size.width < size.height ? (size.height - size.width) / 2 : 0
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let path = UIBezierPath(
                rect: .init(
                    x: ovalX, y: ovalY, width: minSize, height: minSize
                )
            )
            
            path.addClip()
            draw(in: .init(origin: .zero, size: size))
        }
    }
    
    func proportionCut(x: Int, y: Int) -> UIImage {
        
        let cgX = CGFloat(x), cgY = CGFloat(y)
        
        let _x: CGFloat
        let _y: CGFloat
        let height: CGFloat
        let width: CGFloat
        
        if size.width < size.height {
            if x < y {
                _x = 0
                width = size.width
                height = size.width * (cgY / cgX)
                _y = (size.height -  height) / 2
            } else {
                _y = 0
                width = size.height * (cgX / cgY)
                height = size.height
                _x = (size.width - width) / 2
            }
        } else {
            if x < y {
                _x = 0
                width = size.height * (cgX / cgY)
                height = size.height
                _y = (size.height -  height) / 2
            } else {
                _x = 0
                width = size.width
                height = size.width * (cgY / cgX)
                _y = (size.height -  height) / 2
            }
        }
       
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let path = UIBezierPath(
                rect: .init(
                    x: _x, y: _y, width: width, height: height
                )
            )
            
            path.addClip()
            draw(in: .init(origin: .zero, size: size))
        }
    }
    
    func rmBG() -> UIImage {
        let scaledOut = BackgroundRemoval
            .init()
            .removeBackground(image: self, maskOnly: false)
        return scaledOut
    }
}
