//
//  AdjustableView.swift
//  Flitrr
//
//  Created by VladyslavMac on 26.04.2022.
//

import UIKit

final class AdjustableView: UIView {
	
	var gridIsActive = true
	
	var panGestureRecognier: UIPanGestureRecognizer!
	var rotationRecognizer: UIRotationGestureRecognizer!
	
	var uLeftButton: AdjustChevronView!
	var uLeftRecognizer: UIPanGestureRecognizer!
	
	var uRightButton: AdjustChevronView!
	var uRightRecognizer: UIPanGestureRecognizer!
	
	var lLeftButton: AdjustChevronView!
	var lLeftRecognizer: UIPanGestureRecognizer!
	
	var lRightButton: AdjustChevronView!
	var lRightRecognizer: UIPanGestureRecognizer!

	
	var imageView: UIImageView!
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setAdjustMode()
		rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationRecognizer(_:)))
		addGestureRecognizer(rotationRecognizer)
		
		panGestureRecognier = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(_:)))
		addGestureRecognizer(panGestureRecognier)
		
		// rotationRecognizer.require(toFail: panGestureRecognier)
		
		backgroundColor = .clear
		
		imageView = UIImageView(frame: bounds)
		imageView.contentMode = .scaleAspectFit
		addSubview(imageView)
		
		drawOutline()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		gridIsActive.toggle()
		if gridIsActive {
			layer.borderColor = UIColor.clear.cgColor
			UIView.animate(withDuration: 0.3) { [unowned self] in
				uLeftButton.alpha = 0
				uRightButton.alpha = 0
				lLeftButton.alpha = 0
				lRightButton.alpha = 0
			}
		} else {
			layer.borderColor = UIColor.lightGray.cgColor
			UIView.animate(withDuration: 0.3) { [unowned self] in
				uLeftButton.alpha = 1
				uRightButton.alpha = 1
				lLeftButton.alpha = 1
				lRightButton.alpha = 1
			}
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		uLeftButton.frame.origin = .init(x: 0, y: 0)
		uRightButton.frame.origin = .init(x: bounds.width - 15, y: 0)
		lLeftButton.frame.origin = .init(x: 0, y: bounds.height - 15)
		lRightButton.frame.origin = .init(x: bounds.width - 15, y: bounds.height - 15)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setAdjustMode() {
		layer.borderWidth = 0.5
		layer.borderColor = UIColor.lightGray.cgColor
	}
	
	private func drawOutline() {
		uLeftButton = AdjustChevronView(frame: .init(x: 0, y: 0, width: 15, height: 15), corner: .uLeft)
		uLeftRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleULeftRecognizer(_:)))
		addSubview(uLeftButton)
		uLeftButton.addGestureRecognizer(uLeftRecognizer)
		
		uRightButton = AdjustChevronView(frame: .init(x: 0, y: 0, width: 15, height: 15), corner: .uRight)
		addSubview(uRightButton)
		
		lLeftButton = AdjustChevronView(frame: .init(x: 0, y: 0, width: 15, height: 15), corner: .lLeft)
		addSubview(lLeftButton)
		
		lRightButton = AdjustChevronView(frame: .init(x: 0, y: 0, width: 15, height: 15), corner: .lRight)
		addSubview(lRightButton)
	}
	
	@objc func handleRotationRecognizer(_ sender: UIRotationGestureRecognizer) {
		transform = CGAffineTransform(rotationAngle: sender.rotation)
	}
	
	@objc func handlePanRecognizer(_ sender: UIPanGestureRecognizer) {
		let localPos = sender.location(in: self)
		
		guard localPos.x > bounds.width / 4 && localPos.x < 3 * bounds.width / 4 else { return }
		guard localPos.y > bounds.height / 4 && localPos.y < 3 * bounds.height / 4 else { return }
		
		let globalPos = sender.location(in: superview)
		center = globalPos
	}
	
	@objc func handleULeftRecognizer(_ sender: UIPanGestureRecognizer) {
		print(sender.location(in: superview))
		frame.origin = sender.location(in: superview)
		
	}
}
