//
//  ColorSliderView.swift
//  Flitrr
//
//  Created by VladyslavMac on 28.04.2022.

import UIKit

protocol ColorSliderViewDelegate: AnyObject {
	func didReportColor(_ uiColor: UIColor, slider: ColorSliderView)
	func didChangeValue(_ slider: ColorSliderView)
}

final class ColorSliderView: UIView {
	
	enum InitialThumbLocation {
		case start, mid, end
	}
	
	enum SliderType {
		case gradient, darkness, alpha
	}
	
	private(set) var value: CGFloat = 0.0
	var thumbLocation: InitialThumbLocation = .start
	var sliderType: SliderType = .darkness {
		didSet {
			switch sliderType {
			case .gradient:
				gradientLayer.colors = [
					UIColor.red,
					UIColor.orange,
					UIColor.yellow,
					.green,
					.init(red: 0.4, green: 0.4, blue: 1, alpha: 1), .magenta, .red
				].map { $0.cgColor }
			case .darkness:
				gradientLayer.colors = [UIColor.white, UIColor.red, UIColor.black].map { $0.cgColor }
			case .alpha:
				gradientLayer.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
				usesAlpha = true
			}
		}
	}
	
	private var lastInteractionPoint: CGPoint = .zero
	weak var delegate: ColorSliderViewDelegate!
	var gradientLayer: CAGradientLayer!
	
	private var thumbWidth: CGFloat = 14.0
	
	var alphaView: AlphaView!
	private var usesAlpha: Bool = false {
		didSet {
			if usesAlpha {
				alphaView = AlphaView(frame: bounds)
                alphaView.backgroundColor = .clear
				insertSubview(alphaView, at: 0)
			}
		}
	}
	
	var thumbView: UIView!
	private var thumbPanGestureRecognizer: UIPanGestureRecognizer!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		gradientLayer = CAGradientLayer()
		gradientLayer.startPoint = .init(x: 0, y: 0.5)
		gradientLayer.endPoint = .init(x: 1, y: 0.5)
		
		layer.addSublayer(gradientLayer)
		
		thumbView = UIView()
		thumbView.frame.origin.y = -3
		thumbView.backgroundColor = .white
		thumbView.layer.cornerRadius = 3
		addSubview(thumbView)
		
		thumbPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidChange(_:)))
		thumbView.addGestureRecognizer(thumbPanGestureRecognizer)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = bounds
		gradientLayer.cornerRadius = bounds.height / 2
		
		thumbView.frame.size = .init(width: thumbWidth, height: bounds.height + 6)
		alphaView?.frame = bounds
		
		switch thumbLocation {
		case .start:
			thumbView.frame.origin.x = 0
		case .mid:
			lastInteractionPoint = .init(x: bounds.width / 2, y: bounds.midY)
			thumbView.frame.origin.x = bounds.width / 2
		case .end:
			thumbView.frame.origin.x = bounds.width - thumbWidth
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func panGestureDidChange(_ sender: UIPanGestureRecognizer) {
		
		let p = sender.location(in: self)
		let x = p.x
		guard x >= 0 && x <= bounds.width - thumbWidth else { return }
		
		thumbView.frame.origin.x = x
		value = x / bounds.width
		
		switch sliderType {
		case .gradient, .darkness:
			let color = gradientLayer.colorOfPoint(point: .init(x: x, y: bounds.midY))
			lastInteractionPoint = .init(x: x, y: bounds.midY)
			delegate?.didReportColor(color, slider: self)
		case .alpha:
			delegate?.didChangeValue(self)
		}
	}
	
	func getCurrentColor() -> UIColor {
		gradientLayer.colorOfPoint(point: lastInteractionPoint)
	}
}
