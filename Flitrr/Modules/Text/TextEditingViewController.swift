//
//  TextEditingViewController.swift
//  Flitrr
//
//  Created by VladyslavMac on 26.04.2022.
//

import UIKit

final class TextEditingViewController: UIViewController {
	
	private var toolBarView: ToolBarView!
	private var optionsContainerView: ProjectsOptionsContainerView!
	
	private var textView: UITextView!
	private var palette: ColorPaletteCollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .appDark
		
		textView = UITextView(frame: view.bounds)
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.autocorrectionType = .no
		textView.autocapitalizationType = .none
		textView.backgroundColor = .appDark
		textView.textColor = .white
		textView.textAlignment = .center
		textView.text = "Text"
		textView.tintColor = .appAccent
		textView.font = UIFont(name: "PaybAck", size: 75)
		view.addSubview(textView)
		
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		palette = ColorPaletteCollectionView(
			frame: .init(x: 0, y: 0, width: view.bounds.width, height: 90), collectionViewLayout: layout
		)
		palette.paletteDelegate = self
		textView.inputAccessoryView = palette
		
		setupToolBar()
		setupTopViews()
		NSLayoutConstraint.activate([
			textView.topAnchor.constraint(equalTo: optionsContainerView.bottomAnchor),
			textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
		
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		textView.becomeFirstResponder()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	func setupToolBar() {
		toolBarView = ToolBarView(frame: .zero, centerItem: .title)
		toolBarView.leadingItem = .cancel
		toolBarView.trailingItem = .confirm
		toolBarView.title = "Text"
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
	
	func setupTopViews() {
		optionsContainerView = ProjectsOptionsContainerView()
		optionsContainerView.delegate = self
		optionsContainerView.setTitles(["Color", "Fonts", "Style"])
		optionsContainerView.selectedIndex = 0
		optionsContainerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(optionsContainerView)
		NSLayoutConstraint.activate([
			optionsContainerView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
			optionsContainerView.heightAnchor.constraint(equalToConstant: 80),
			optionsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
			optionsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
		])
	}
	
	func hideKeyboardAndTopControls() {
		if textView.isFirstResponder {
			textView.resignFirstResponder()
		}
		UIView.animate(withDuration: 0.3) { [unowned self] in
			toolBarView.alpha = 0
			optionsContainerView.alpha = 0
		} completion: { [unowned self] _ in
			toolBarView.isHidden = true
			optionsContainerView.isHidden = true
		}
	}
	
	func unhideTopControls() {
		UIView.animate(withDuration: 0.3) { [unowned self] in
			toolBarView.alpha = 1
			optionsContainerView.alpha = 1
		} completion: { [unowned self] _ in
			toolBarView.isHidden = false
			optionsContainerView.isHidden = false
		}
	}
	
}

extension TextEditingViewController: ToolBarViewDelegate {
	func didTapTrailingItem() {
	}
	func didTapLeadingItem() {
		dismiss(animated: true)
	}
	func didTapUndo() {}
	func didTapLayers() {}
	func didTapRedo() {}
}

extension TextEditingViewController: ColorPaletteCollectionViewDelegate {
	func didSelectItem(_ item: ColorPaletteItem) {
		switch item {
		case .fill:
			break
		case .textColor:
			break
		case .gradient:
			break
		case .color(let uIColor):
			textView.textColor = uIColor
		}
	}
}

extension TextEditingViewController: ProjectsOptionsContainerViewDelegate {
	func didTapOption(tag: Int) {
		switch tag {
		case 0:
			break
		case 1:
			hideKeyboardAndTopControls()
			let vc = FontsPickerViewController()
			vc.initialFont = textView.font
			vc.delegate = self
			if let presentationController = vc.presentationController as? UISheetPresentationController {
				presentationController.detents = [.medium()]
			}
			present(vc, animated: true, completion: nil)
		case 2:
			hideKeyboardAndTopControls()
		default:
			break
		}
	}
}

extension TextEditingViewController: FontsPickerViewControllerDelegate {
	func didDismissFontPicker() {
		unhideTopControls()
	}
	func didSelect(font: UIFont?) {
		textView.font = font
	}
}
