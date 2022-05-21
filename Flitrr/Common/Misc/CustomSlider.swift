//
//  CustomSlider.swift
//  Flitrr
//
//  Created by VladyslavMac on 29.04.2022.
//

import UIKit

final class CustomSlider: UISlider {

	override init(frame: CGRect) {
		super.init(frame: frame)
		minimumTrackTintColor = .white
		maximumTrackTintColor = .soft2
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func trackRect(forBounds bounds: CGRect) -> CGRect {
		return .init(x: 0, y: 20, width: bounds.width, height: 1.75)
	}
}

final class CustomSliderContainerView: UIView {
	var slider: CustomSlider!
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		slider = CustomSlider()
        slider.frame = bounds
		addSubview(slider)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		slider.frame = bounds
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
