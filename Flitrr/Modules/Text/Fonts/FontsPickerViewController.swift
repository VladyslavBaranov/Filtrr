//
//  FontsPickerViewController.swift
//  Flitrr
//
//  Created by VladyslavMac on 28.04.2022.
//

import UIKit

protocol FontsPickerViewControllerDelegate: AnyObject {
	func didDismissFontPicker()
	func didSelect(font: UIFont?)
}

final class FontsPickerViewController: UIViewController {
	
	var initialFont: UIFont?
	
	var currentFonts: [FontSystem.Font] = []
	
	private var fontsLoader: FontsLoader!
	
	weak var delegate: FontsPickerViewControllerDelegate!
	
	private var toolBarView: ToolBarView!
	private var fontsCollectionView: UICollectionView!
	
	private var familyPickerView: ValuePickerView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .appGray
		setupToolBar()
		setupFontsCollectionView()
		setupFontPicker()
		
		fontsLoader = FontsLoader()
		familyPickerView.titles = fontsLoader.getFontCategories()
		currentFonts = fontsLoader.fonts(for: 0)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		delegate?.didDismissFontPicker()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		familyPickerView.frame = .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80)
	}
	
	func setupToolBar() {
		toolBarView = ToolBarView(frame: .zero, centerItem: .title)
		toolBarView.leadingItem = .cancel
		toolBarView.trailingItem = .confirm
		toolBarView.title = "Fonts"
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
	
	func setupFontsCollectionView() {
		fontsCollectionView = UICollectionView(
			frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		fontsCollectionView.contentInset = .init(top: 0, left: 0, bottom: 80, right: 0)
		fontsCollectionView.backgroundColor = .appGray
		fontsCollectionView.delegate = self
		fontsCollectionView.dataSource = self
		fontsCollectionView.register(TextCollectionViewCell.self, forCellWithReuseIdentifier: "id")
		fontsCollectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(fontsCollectionView)
		NSLayoutConstraint.activate([
			fontsCollectionView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
			fontsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			fontsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			fontsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	func setupFontPicker() {
		familyPickerView = ValuePickerView(
			frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
		familyPickerView.delegate = self
		view.addSubview(familyPickerView)
	}
}

extension FontsPickerViewController: ToolBarViewDelegate {
	func didTapTrailingItem() {
		dismiss(animated: true)
	}
	func didTapLeadingItem() {
		delegate?.didSelect(font: initialFont)
		dismiss(animated: true) { [weak self] in
			self?.delegate?.didDismissFontPicker()
		}
	}
	func didTapUndo() {}
	func didTapLayers() {}
	func didTapRedo() {}
}

extension FontsPickerViewController:
	UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let font = currentFonts[indexPath.row]
		delegate?.didSelect(font: .init(name: font.fontname, size: 75))
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		currentFonts.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: "id", for: indexPath) as! TextCollectionViewCell
		let item = currentFonts[indexPath.row]
		cell.setTextAndFont(text: item.name, name: item.fontname, size: 25)
		cell.textColor = .white
		cell.backgroundColor = .soft2
		cell.layer.cornerRadius = 10
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		20
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		20
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		.init(width: collectionView.bounds.width - 40, height: 50)
	}
}

extension FontsPickerViewController: ValuePickerViewDelegate {
	func didSelectValue(at index: Int) {
		currentFonts = fontsLoader.fonts(for: index)
		fontsCollectionView.reloadData()
	}
}
