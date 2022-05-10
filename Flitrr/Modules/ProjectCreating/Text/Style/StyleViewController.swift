//
//  StyleViewController.swift
//  Flitrr
//
//  Created by VladyslavMac on 28.04.2022.
//

import UIKit

protocol StyleViewControllerDelegate: AnyObject {
	func didSetAttributes(_ attributes: [NSAttributedString.Key: Any])
	func didDismissStyleController()
}

final class StyleViewController: UIViewController {
	
	private var currentTextAlignment = NSTextAlignment.center
	var initialAttributes: [NSAttributedString.Key: Any] = [:]
	
	weak var delegate: StyleViewControllerDelegate!
	private var toolBarView: ToolBarView!
	
	private var optionsContainerView: ProjectsOptionsContainerView!
	private var fontSizeContainerView: CustomSliderContainerView!
	private var letterSpacingContainerView: CustomSliderContainerView!
	private var lineSpacingContainerView: CustomSliderContainerView!
	private var stackView: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .appGray
		setupToolBar()
		setupStack()
	}
	
	private func setupStack() {
		stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
		
		let alignmentLabel = createTitle(
            LocalizationManager.shared.localizedString(for: .textFontsAlignment)
        )
		stackView.addArrangedSubview(alignmentLabel)
		
		optionsContainerView = ProjectsOptionsContainerView()
		optionsContainerView.delegate = self
		optionsContainerView.setTitles([
            LocalizationManager.shared.localizedString(for: .textFontsLeft),
            LocalizationManager.shared.localizedString(for: .textFontsCenter),
            LocalizationManager.shared.localizedString(for: .textFontsRight)
        ])
		optionsContainerView.translatesAutoresizingMaskIntoConstraints = false
		optionsContainerView.selectedIndex = 1
		stackView.addArrangedSubview(optionsContainerView)
		
		let fontSizeLabel = createTitle(
            LocalizationManager.shared.localizedString(for: .textFontsSize)
        )
		stackView.addArrangedSubview(fontSizeLabel)
		
		fontSizeContainerView = CustomSliderContainerView(frame: .zero)
		fontSizeContainerView.slider.value = 0.5
		fontSizeContainerView.slider.addTarget(self, action: #selector(fontSizeDidChange(_:)), for: .valueChanged)
		stackView.addArrangedSubview(fontSizeContainerView)
		
		let letterSpacingLabel = createTitle(
            LocalizationManager.shared.localizedString(for: .textFontsLetterSpacing)
        )
		stackView.addArrangedSubview(letterSpacingLabel)
		
		letterSpacingContainerView = CustomSliderContainerView(frame: .zero)
		letterSpacingContainerView.slider.addTarget(self, action: #selector(letterSpacingDidChange(_:)), for: .valueChanged)
		stackView.addArrangedSubview(letterSpacingContainerView)
		
		let lineSpacingLabel = createTitle(
            LocalizationManager.shared.localizedString(for: .textFontsLineSpacing)
        )
		stackView.addArrangedSubview(lineSpacingLabel)
		
		lineSpacingContainerView = CustomSliderContainerView(frame: .zero)
		lineSpacingContainerView.slider.addTarget(self, action: #selector(lineSpacingDidChange(_:)), for: .valueChanged)
		stackView.addArrangedSubview(lineSpacingContainerView)
	}
	
	@objc private func fontSizeDidChange(_ sender: UISlider) {
		let fontSize = 100 * sender.value + 25
		var attributesCopy = initialAttributes
		if let font = attributesCopy[.font] as? UIFont {
			attributesCopy[.font] = font.withSize(CGFloat(fontSize))
			delegate?.didSetAttributes(attributesCopy)
		}
	}
	
	@objc private func letterSpacingDidChange(_ sender: UISlider) {
		let letterSpacing = 40 * sender.value
		var attributesCopy = initialAttributes
		attributesCopy[.kern] = letterSpacing
		delegate?.didSetAttributes(attributesCopy)
	}
	
	@objc private func lineSpacingDidChange(_ sender: UISlider) {
		let lineSpacing = 40 * sender.value
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = CGFloat(lineSpacing)
		paragraphStyle.alignment = currentTextAlignment
		var attributesCopy = initialAttributes
		attributesCopy[.paragraphStyle] = paragraphStyle
		delegate?.didSetAttributes(attributesCopy)
	}
	
	private func setupToolBar() {
		toolBarView = ToolBarView(frame: .zero, centerItem: .title)
		toolBarView.leadingItem = .cancel
		toolBarView.trailingItem = .confirm
		toolBarView.title = LocalizationManager.shared.localizedString(for: .textStyle)
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
	
	private func createTitle(_ title: String) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = title
		label.font = Montserrat.regular(size: 12)
		label.textAlignment = .left
		label.textColor = .lightGray
		return label
	}
}

extension StyleViewController: ToolBarViewDelegate {
	func didTapTrailingItem() {
		delegate?.didDismissStyleController()
		dismiss(animated: true)
	}
	func didTapLeadingItem() {
		delegate?.didSetAttributes(initialAttributes)
		delegate?.didDismissStyleController()
		dismiss(animated: true)
	}
	func didTapUndo() {}
	func didTapLayers() {}
	func didTapRedo() {}
}

extension StyleViewController: ProjectsOptionsContainerViewDelegate {
	func didTapOption(tag: Int) {
		
		var attributesCopy = initialAttributes

		let paragraphStyle = NSMutableParagraphStyle()
		switch tag {
		case 0:
			currentTextAlignment = .left
		case 1:
			currentTextAlignment = .center
		case 2:
			currentTextAlignment = .right
		default:
			break
		}
		paragraphStyle.alignment = currentTextAlignment
		attributesCopy[NSAttributedString.Key.paragraphStyle] = paragraphStyle
		delegate?.didSetAttributes(attributesCopy)
	}
}

extension StyleViewController: UIViewControllerTransitioningDelegate {
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		FractionPresentationController(presentedViewController: presented, presenting: presenting, heightFactor: 0.5)
	}
}
