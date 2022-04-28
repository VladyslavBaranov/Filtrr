//
//  TextCollectionViewCell.swift
//  Flitrr
//
//  Created by VladyslavMac on 28.04.2022.
//

import UIKit

final class TextCollectionViewCell: UICollectionViewCell {
	
	private var label: UILabel!
	
	var textColor: UIColor = .white {
		didSet {
			label.textColor = textColor
		}
	}
	
	var usesBorder: Bool = false {
		didSet {
			layer.borderWidth = usesBorder ? 1 : 0
			layer.borderColor = usesBorder ? UIColor.soft2.cgColor : UIColor.clear.cgColor
		}
	}
	
	var usesMontserrat13: Bool = true {
		didSet {
			if usesMontserrat13 {
				label.font = Montserrat.regular(size: 13)
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		label = UILabel()
		addSubview(label)
		label.textAlignment = .center
		label.backgroundColor = .clear
		label.textColor = .soft2
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		label.frame = bounds
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func set(text: String) {
		label.text = text
		// label.sizeToFit()
	}
	
	func setTextAndFont(text: String, name: String, size: CGFloat) {
		label.text = text
		label.font = UIFont(name: name, size: size)
	}
	
	func getLabelBoundingWidth() -> CGFloat {
		label.bounds.width
	}
	
	func setSelected() {
		label.textColor = .white
		backgroundColor = .soft2
	}
	
	func setUnselected() {
		label.textColor = .soft2
		backgroundColor = .appGray
	}
}

