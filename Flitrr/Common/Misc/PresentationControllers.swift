//
//  PresentationControllers.swift
//  Flitrr
//
//  Created by VladyslavMac on 29.04.2022.
//

import UIKit

final class FractionPresentationController: UIPresentationController {
	
	private var heightFactor: CGFloat
	
	init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, heightFactor: CGFloat) {
		self.heightFactor = heightFactor
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
	}
  
	override var frameOfPresentedViewInContainerView: CGRect {
		guard let bounds = containerView?.bounds else { return .zero }
		return .init(
			x: 0,
			y: bounds.height - bounds.height * heightFactor,
			width: bounds.width,
			height: bounds.height * heightFactor
		)
	}
	
	override func containerViewDidLayoutSubviews() {
		super.containerViewDidLayoutSubviews()
		presentedView?.frame = frameOfPresentedViewInContainerView
	}
	
	override func presentationTransitionWillBegin() {
		super.presentationTransitionWillBegin()
		presentedView?.layer.cornerRadius = 12
	}
}
