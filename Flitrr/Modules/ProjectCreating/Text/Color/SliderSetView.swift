//
//  SliderSetView.swift
//  Flitrr
//
//  Created by VladyslavMac on 29.04.2022.
//

import UIKit

protocol SliderSetViewDelegate: AnyObject {
	func didReportColor(_ uiColor: UIColor, alphaPercent: Int)
}

final class SliderSetView: UIView {
	
	private var red: CGFloat = 1
	private var green: CGFloat = 0
	private var blue: CGFloat = 0
	private var alphaComponent: CGFloat = 1
	
	private var gradientSlider: ColorSliderView!
	private var monoSlider: ColorSliderView!
	private var alphaSlider: ColorSliderView!
	
	weak var delegate: SliderSetViewDelegate!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		gradientSlider = ColorSliderView(frame: .zero)
		gradientSlider.sliderType = .gradient
		gradientSlider.thumbLocation = .start
		gradientSlider.delegate = self
		addSubview(gradientSlider)
		
		monoSlider = ColorSliderView(frame: .zero)
		monoSlider.delegate = self
		monoSlider.sliderType = .darkness
		monoSlider.thumbLocation = .mid
		addSubview(monoSlider)
		
		alphaSlider = ColorSliderView(frame: .zero)
		alphaSlider.delegate = self
		alphaSlider.sliderType = .alpha
		alphaSlider.thumbLocation = .end
		addSubview(alphaSlider)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientSlider.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.height / 6)
		monoSlider.frame = .init(x: 0, y: bounds.midY - bounds.height / 12, width: bounds.width, height: bounds.height / 6)
		alphaSlider.frame = .init(x: 0, y: bounds.height - bounds.height / 6, width: bounds.width, height: bounds.height / 6)
	}
}

extension SliderSetView: ColorSliderViewDelegate {
	func didReportColor(_ uiColor: UIColor, slider: ColorSliderView) {
		
		switch slider.sliderType {
		case .gradient:
			monoSlider.gradientLayer.colors?[1] = uiColor.cgColor
			alphaSlider.gradientLayer.colors?[1] = uiColor.cgColor
			
			let monoColor = monoSlider.getCurrentColor().cgColor
			
			red = monoColor.components?[0] ?? 0.0
			green = monoColor.components?[1] ?? 0.0
			blue = monoColor.components?[2] ?? 0.0
			
			delegate?.didReportColor(
				UIColor(red: red, green: green, blue: blue, alpha: alphaComponent),
				alphaPercent: Int(alphaComponent * 100)
			)
		case .darkness:
			red = uiColor.cgColor.components?[0] ?? 0.0
			green = uiColor.cgColor.components?[1] ?? 0.0
			blue = uiColor.cgColor.components?[2] ?? 0.0
			
			delegate?.didReportColor(
				UIColor(red: red, green: green, blue: blue, alpha: alphaComponent),
				alphaPercent: Int(alphaComponent * 100)
			)
		default:
			break
		}
		
	}
	
	func didChangeValue(_ slider: ColorSliderView) {
		switch slider.sliderType {
		case .alpha:
			alphaComponent = slider.value
			delegate?.didReportColor(
				UIColor(red: red, green: green, blue: blue, alpha: alphaComponent),
				alphaPercent: Int(alphaComponent * 100)
			)
		default:
			break
		}
	}
}
