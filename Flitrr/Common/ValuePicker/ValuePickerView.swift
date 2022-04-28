//
//  ValuePickerView.swift
//  Flitrr
//
//  Created by VladyslavMac on 28.04.2022.
//

import UIKit

protocol ValuePickerViewDelegate: AnyObject {
	func didSelectValue(at index: Int)
}

final class ValuePickerView: UIView {
	
	weak var delegate: ValuePickerViewDelegate!
	
	struct Item {
		var title: String
		var isSelected: Bool
	}
	
	var titles: [String] = [] {
		didSet {
			items = titles.map { .init(title: $0, isSelected: false) }
			// items[0].isSelected = true
			collectionView.reloadData()
		}
	}
	
	var items: [Item] = []
	
	var collectionView: UICollectionView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .soft2
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		collectionView.frame = .init(x: 0, y: 1, width: bounds.width, height: bounds.height - 1)
	}
	
	func setupUI() {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		collectionView = UICollectionView(
			frame: .init(x: 0, y: 1, width: bounds.width, height: bounds.height - 1),
			collectionViewLayout: layout
		)
		addSubview(collectionView)
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(TextCollectionViewCell.self, forCellWithReuseIdentifier: "id")
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.backgroundColor = .appGray
		collectionView.contentInset = .init(top: 20, left: 0, bottom: 30, right: 20)
		collectionView.selectItem(at: .init(index: 0), animated: false, scrollPosition: .centeredHorizontally)
	}
}

extension ValuePickerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! TextCollectionViewCell
		cell.set(text: titles[indexPath.row])
		cell.usesMontserrat13 = true
		cell.usesBorder = true
		cell.layer.cornerRadius = 10
		if items[indexPath.row].isSelected {
			cell.setSelected()
		} else {
			cell.setUnselected()
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! TextCollectionViewCell
		cell.setSelected()
		delegate?.didSelectValue(at: indexPath.row)
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! TextCollectionViewCell
		cell.setUnselected()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(
			width: Montserrat.getBoundingWidthRegular13(string: titles[indexPath.row]) + 20,
			height: 30
		)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		16
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		16
	}
}
