//
//  ColorPaletteCollectionView.swift
//  Flitrr
//
//  Created by VladyslavMac on 26.04.2022.
//

import UIKit

enum ColorPaletteItem {
	case fill
	case textColor
	case gradient
	case color(UIColor)
}

final class ColorPaletteCollectionViewCell: UICollectionViewCell {
	
	var imageView: UIImageView!
	var currentItem: ColorPaletteItem = .fill {
		didSet {
			imageView.isHidden = false
			switch currentItem {
			case .fill:
				backgroundColor = .clear
				imageView.image = UIImage(named: "Eyedropper")
			case .textColor:
				backgroundColor = .clear
				imageView.image = UIImage(named: "FillOff")
			case .gradient:
				backgroundColor = .clear
				imageView.image = UIImage(named: "ColorPicker")
			case .color(let uIColor):
				imageView.isHidden = true
				backgroundColor = uIColor
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		imageView = UIImageView(frame: frame)
		addSubview(imageView)
		imageView.image = UIImage(named: "ColorPicker")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		imageView.frame = bounds
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

protocol ColorPaletteCollectionViewDelegate: AnyObject {
	func didSelectItem(_ item: ColorPaletteItem)
}

final class ColorPaletteCollectionView: UICollectionView {
	
	private let paletteItems: [ColorPaletteItem] = [
		.fill, .textColor, .gradient,
		.color(.white), .color(.black),
		.color(UIColor(red: 1, green: 0.02, blue: 0.4, alpha: 1)),
		.color(UIColor(red: 0.761, green: 0.09, blue: 0.49, alpha: 1)),
		.color(UIColor.darkGray),
		.color(UIColor.gray),
		.color(.lightGray),
		.color(.red),
		.color(.orange),
		.color(.yellow),
		.color(.green),
		.color(.cyan),
		.color(.blue),
		.color(.purple)
	]
	
	weak var paletteDelegate: ColorPaletteCollectionViewDelegate!
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: frame, collectionViewLayout: layout)
		backgroundColor = .clear
		delegate = self
		dataSource = self
		contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
		showsHorizontalScrollIndicator = false
		register(ColorPaletteCollectionViewCell.self, forCellWithReuseIdentifier: "id")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension ColorPaletteCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		paletteItems.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ColorPaletteCollectionViewCell
		cell.currentItem = paletteItems[indexPath.row]
		cell.layer.cornerRadius = 25
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		paletteDelegate?.didSelectItem(paletteItems[indexPath.row])
	}
}

extension ColorPaletteCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		16
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		16
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		.init(width: 50, height: 50)
	}
}
