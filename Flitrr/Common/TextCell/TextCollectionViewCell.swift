//
//  TextCollectionViewCell.swift
//  Flitrr
//
//  Created by VladyslavMac on 28.04.2022.
//

import UIKit

final class TextCollectionViewCell: UICollectionViewCell {
	
    var pickerStyle: PickerStyle = .style1 {
        didSet {
            switch pickerStyle {
            case .style1:
                usesMontserrat13 = true
            case .style2:
                backgroundColor = .clear
                usesMontserrat15 = true
            }
        }
    }
    
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
    
    var usesMontserrat15: Bool = true {
        didSet {
            if usesMontserrat15 {
                label.font = Montserrat.regular(size: 15)
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
        switch pickerStyle {
        case .style1:
            label.textColor = .white
            backgroundColor = .soft2
            layer.borderColor = usesBorder ? UIColor.soft2.cgColor : UIColor.clear.cgColor
        case .style2:
            label.textColor = .appAccent
            backgroundColor = .clear
            layer.borderColor = UIColor.appAccent.cgColor
        }
	}
	
	func setUnselected() {
        switch pickerStyle {
        case .style1:
            label.textColor = .soft2
            backgroundColor = .appGray
        case .style2:
            label.textColor = .label
            backgroundColor = .clear
        }
	}
}

