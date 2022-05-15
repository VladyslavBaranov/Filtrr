//
//  TextEditingViewController.swift
//  Flitrr
//
//  Created by VladyslavMac on 26.04.2022.
//

import UIKit

protocol TextEditingViewControllerDelegate: AnyObject {
    func didConfirmText(_ attributedString: NSAttributedString)
}

final class TextEditingViewController: UIViewController {
	
    weak var delegate: TextEditingViewControllerDelegate!
    
	private var toolBarView: ToolBarView!
	private var optionsContainerView: ProjectsOptionsContainerView!
	
	private var textView: UITextView!
	private var palette: ColorPaletteCollectionView!
	
	private var textViewAttributes: [NSAttributedString.Key: Any] = [
		.font: UIFont(name: "PaybAck", size: 75) ?? .systemFont(ofSize: 75),
		.foregroundColor: UIColor.white
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = .center
		textViewAttributes[.paragraphStyle] = paragraph
		
		view.backgroundColor = .appDark
		
		textView = UITextView(frame: view.bounds)
		textView.delegate = self
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.autocorrectionType = .no
		textView.autocapitalizationType = .none
		textView.backgroundColor = .appDark
		textView.textColor = .label
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
        toolBarView.title = LocalizationManager.shared.localizedString(for: .textTitle)
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
		optionsContainerView.allowsBorderSelection = false
		optionsContainerView.delegate = self
		optionsContainerView.setTitles(
            [
                LocalizationManager.shared.localizedString(for: .textColor),
                LocalizationManager.shared.localizedString(for: .textFonts),
                LocalizationManager.shared.localizedString(for: .textStyle)
            ]
        )
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
		toolBarView.isHidden = false
		optionsContainerView.isHidden = false
		UIView.animate(withDuration: 0.3) { [unowned self] in
			toolBarView.alpha = 1
			optionsContainerView.alpha = 1
		}
	}
	
}

extension TextEditingViewController: ToolBarViewDelegate {
	func didTapTrailingItem() {
        dismiss(animated: true)
        delegate?.didConfirmText(textView.attributedText)
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
		case .picker:
			hideKeyboardAndTopControls()
			let vc = ColorPickerViewController()
			vc.initialColor = textView.textColor
			vc.delegate = self
			vc.modalPresentationStyle = .custom
			vc.transitioningDelegate = vc
			present(vc, animated: true, completion: nil)
		case .color(let uIColor):
			textViewAttributes[.foregroundColor] = uIColor
			textView.attributedText = NSAttributedString(string: textView.text, attributes: textViewAttributes)
        case .gradient(_, _, _):
            break
        case .transparent:
            break
        default:
            break
        }
	}
}

extension TextEditingViewController: ProjectsOptionsContainerViewDelegate {
	func didTapOption(tag: Int) {
		hideKeyboardAndTopControls()
		switch tag {
		case 0:
			let vc = ColorPickerViewController()
			vc.initialColor = textView.textColor
			vc.delegate = self
			vc.modalPresentationStyle = .custom
			vc.transitioningDelegate = vc
			present(vc, animated: true, completion: nil)
		case 1:
			let vc = FontsPickerViewController()
			vc.initialFont = textView.font
			vc.delegate = self
			vc.modalPresentationStyle = .custom
			vc.transitioningDelegate = vc
			present(vc, animated: true, completion: nil)
		case 2:
			let vc = StyleViewController()
			vc.initialAttributes = textViewAttributes
			vc.delegate = self
			vc.modalPresentationStyle = .custom
			vc.transitioningDelegate = vc
			present(vc, animated: true, completion: nil)
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
		textViewAttributes[.font] = font
		textView.attributedText = NSAttributedString(string: textView.text, attributes: textViewAttributes)
	}
}

extension TextEditingViewController: ColorPickerViewControllerDelegate {
	func didDismissColorPicker() {
		unhideTopControls()
	}
	
	func didReportColor(_ uiColor: UIColor) {
		textViewAttributes[.foregroundColor] = uiColor
		textView.attributedText = NSAttributedString(string: textView.text, attributes: textViewAttributes)
	}
}

extension TextEditingViewController: StyleViewControllerDelegate {
	func didSetAttributes(_ attributes: [NSAttributedString.Key : Any]) {
		textViewAttributes = attributes
		textView.attributedText = NSAttributedString(string: textView.text, attributes: textViewAttributes)
	}

	func didDismissStyleController() {
		unhideTopControls()
	}
}

extension TextEditingViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		textView.attributedText = NSAttributedString(string: textView.text, attributes: textViewAttributes)
	}
}
