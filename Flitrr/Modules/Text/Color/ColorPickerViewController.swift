//
//  ColorPickerViewController.swift
//  Flitrr
//
//  Created by VladyslavMac on 28.04.2022.
//

import UIKit

protocol ColorPickerViewControllerDelegate: AnyObject {
	func didDismissColorPicker()
	func didReportColor(_ uiColor: UIColor)
}

final class ColorPickerViewController: UIViewController {
	
	var initialColor: UIColor!
	
	weak var delegate: ColorPickerViewControllerDelegate!
	
	private var toolBarView: ToolBarView!
	
	private var slidersContainer: SliderSetView!
	
	var slider: ColorSliderView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .appGray
		setupToolBar()
		
		slidersContainer = SliderSetView(frame: .zero)
		slidersContainer.delegate = self
		slidersContainer.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(slidersContainer)
		
		NSLayoutConstraint.activate([
			slidersContainer.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
			slidersContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			slidersContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			slidersContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
		])
		
	}

	func setupToolBar() {
		toolBarView = ToolBarView(frame: .zero, centerItem: .colorData)
		toolBarView.leadingItem = .cancel
		toolBarView.trailingItem = .confirm
		toolBarView.title = "Color"
		toolBarView.delegate = self
		toolBarView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(toolBarView)
		
		NSLayoutConstraint.activate([
			toolBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			toolBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			toolBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			toolBarView.heightAnchor.constraint(equalToConstant: 80)
		])
	}
}

extension ColorPickerViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		FractionPresentationController(presentedViewController: presented, presenting: presenting, heightFactor: 0.3)
	}
}

extension ColorPickerViewController: ToolBarViewDelegate {
	func didTapTrailingItem() {
		delegate?.didDismissColorPicker()
		dismiss(animated: true)
	}
	
	func didTapLeadingItem() {
        delegate?.didReportColor(initialColor ?? .clear)
		delegate?.didDismissColorPicker()
		dismiss(animated: true)
	}
	
	func didTapUndo() {}
	func didTapLayers() {}
	func didTapRedo() {}
}

extension ColorPickerViewController: SliderSetViewDelegate {
	func didReportColor(_ uiColor: UIColor, alphaPercent: Int) {
		delegate?.didReportColor(uiColor)
		toolBarView.setColor(uiColor, alphaPercent: alphaPercent)
	}
}
