//
//  AdjustableView.swift
//  Flitrr
//
//  Created by VladyslavMac on 26.04.2022.
//

import UIKit

protocol AdjustableViewDelegate: AnyObject {
    func didToggle(_ view: AdjustableView)
    func frameDidChange(_ view: AdjustableView)
}

class AdjustableView: UIView {
	
    weak var delegate: AdjustableViewDelegate!
    
    var isTransformingEnabled = true
	var savedFrame: CGRect = .zero
    var gridIsActive = true {
        didSet {
            if !gridIsActive {
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
    }
	
	private var panGestureRecognier: UIPanGestureRecognizer!
	private var rotationRecognizer: UIRotationGestureRecognizer!

	private var uLeftButton: AdjustChevronView!
	private var uLeftRecognizer: UIPanGestureRecognizer!

	private var uRightButton: AdjustChevronView!
	private var uRightRecognizer: UIPanGestureRecognizer!

	private var lLeftButton: AdjustChevronView!
	private var lLeftRecognizer: UIPanGestureRecognizer!

	private var lRightButton: AdjustChevronView!
	private var lRightRecognizer: UIPanGestureRecognizer!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setAdjustMode()
		rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationRecognizer(_:)))
		addGestureRecognizer(rotationRecognizer)
		
		panGestureRecognier = UIPanGestureRecognizer(target: self, action: #selector(handlePanRecognizer(_:)))
		addGestureRecognizer(panGestureRecognier)
		
		backgroundColor = .clear
		
		drawOutline()
		
		savedFrame = frame
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		gridIsActive.toggle()
        delegate?.didToggle(self)
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
        uRightRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleURightRecognizer(_:)))
        uRightButton.addGestureRecognizer(uRightRecognizer)
		addSubview(uRightButton)
		
		lLeftButton = AdjustChevronView(frame: .init(x: 0, y: 0, width: 15, height: 15), corner: .lLeft)
		addSubview(lLeftButton)
        lLeftRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleLLeftRecognizer(_:)))
        lLeftButton.addGestureRecognizer(lLeftRecognizer)
		
		lRightButton = AdjustChevronView(frame: .init(x: 0, y: 0, width: 15, height: 15), corner: .lRight)
		addSubview(lRightButton)
        lRightRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleLRightRecognizer(_:)))
        lRightButton.addGestureRecognizer(lRightRecognizer)
	}
    
    func untoggle() {
        gridIsActive = false
        for subview in subviews {
            (subview as? AdjustableView)?.untoggle()
        }
    }
	
	@objc func handleRotationRecognizer(_ sender: UIRotationGestureRecognizer) {
        guard isTransformingEnabled else { return }
        transform = CGAffineTransform(rotationAngle: sender.rotation)
        // print(frame)
	}
	
	@objc func handlePanRecognizer(_ sender: UIPanGestureRecognizer) {
        guard isTransformingEnabled else { return }
		let localPos = sender.location(in: self)
		
		guard localPos.x > bounds.width / 4 && localPos.x < 3 * bounds.width / 4 else { return }
		guard localPos.y > bounds.height / 4 && localPos.y < 3 * bounds.height / 4 else { return }
		
		let globalPos = sender.location(in: superview)
		center = globalPos
		savedFrame = frame
        delegate?.frameDidChange(self)
	}
	
	@objc func handleULeftRecognizer(_ sender: UIPanGestureRecognizer) {
        guard isTransformingEnabled else { return }
		let location = sender.location(in: superview)
		
		switch sender.state {
        case .began:
            gridIsActive = true
            break
		case .changed:
			frame.origin = location
			frame.size = .init(
				width: abs(savedFrame.maxX - location.x),
				height: abs(savedFrame.maxY - location.y)
			)
		case .ended:
			savedFrame = frame
		default:
			break
		}

	}
    
    @objc func handleURightRecognizer(_ sender: UIPanGestureRecognizer) {
        guard isTransformingEnabled else { return }
        let location = sender.location(in: superview)
        
        switch sender.state {
        case .began:
            gridIsActive = true
            break
        case .changed:
            frame.origin.y = location.y
            frame.size = .init(
                width: abs(location.x - savedFrame.minX), //abs(savedFrame.maxX - location.x)
                height: abs(savedFrame.maxY - location.y)
            )
        case .ended:
            savedFrame = frame
        default:
            break
        }

    }
    
    @objc func handleLRightRecognizer(_ sender: UIPanGestureRecognizer) {
        guard isTransformingEnabled else { return }
        let location = sender.location(in: superview)
        
        switch sender.state {
        case .began:
            gridIsActive = true
            break
        case .changed:
            frame.size = .init(
                width: abs(location.x - savedFrame.minX), //abs(savedFrame.maxX - location.x)
                height: abs(location.y - savedFrame.minY)
            )
        case .ended:
            savedFrame = frame
        default:
            break
        }

    }
    
    @objc func handleLLeftRecognizer(_ sender: UIPanGestureRecognizer) {
        guard isTransformingEnabled else { return }
        let location = sender.location(in: superview)
        
        switch sender.state {
        case .began:
            gridIsActive = true
            break
        case .changed:
            frame.origin.x = location.x
            
            frame.size = .init(
                width: abs(savedFrame.maxX - location.x), //abs(savedFrame.maxX - location.x)
                height: abs(location.y - savedFrame.minY)
            )
        case .ended:
            savedFrame = frame
        default:
            break
        }

    }
}
