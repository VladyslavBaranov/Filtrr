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
    case picker
    case transparent
	case color(UIColor)
    case gradient([UIColor], CGPoint, CGPoint)
    case image(UIImage)
}

final class ColorPaletteCollectionViewCell: UICollectionViewCell {
	
    var gradientLayer: CAGradientLayer!
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
			case .picker:
				backgroundColor = .clear
				imageView.image = UIImage(named: "ColorPicker")
			case .color(let uIColor):
                gradientLayer.opacity = 0
				imageView.isHidden = true
				backgroundColor = uIColor
            case .transparent:
                imageView.isHidden = false
                gradientLayer.opacity = 0
                backgroundColor = .clear
                imageView.image = UIImage(named: "Transparent")
            case .gradient(let colors, _, _):
                gradientLayer.colors = colors.map { $0.cgColor }
                gradientLayer.startPoint = .zero
                gradientLayer.endPoint = .init(x: 1, y: 1)
                imageView.isHidden = true
                gradientLayer.opacity = 1
            default:
                break
            }
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
        gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 25
        layer.addSublayer(gradientLayer)
		imageView = UIImageView(frame: frame)
		addSubview(imageView)
		imageView.image = UIImage(named: "ColorPicker")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		imageView.frame = bounds
        gradientLayer.frame = bounds
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

protocol ColorPaletteCollectionViewDelegate: AnyObject {
	func didSelectItem(_ item: ColorPaletteItem)
}

final class ColorPaletteCollectionView: UICollectionView {
	
	var paletteItems: [ColorPaletteItem] = [
		.fill, .textColor, .picker,
		.color(.white), .color(.black),
		.color(UIColor(red: 1, green: 0.02, blue: 0.4, alpha: 1)),
		.color(UIColor(red: 0.761, green: 0.09, blue: 0.49, alpha: 1)),
        .gradient([.red, .purple], .zero, .init(x: 1, y: 1)),
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
    
    func backgroundSetColors() {
        paletteItems = [
            .transparent,
            .color(.appAccent),
            .color(UIColor(red: 1, green: 0.02, blue: 0.5, alpha: 1)),
            .color(UIColor(red: 0.761, green: 0.09, blue: 0.49, alpha: 1)),
            .color(UIColor(red: 0.38, green: 0.102, blue: 0.784, alpha: 1)),
            .color(UIColor(red: 0.29, green: 0.384, blue: 0.851, alpha: 1)),
            .color(UIColor(red: 0, green: 0.471, blue: 0.565, alpha: 1)),
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
        reloadData()
    }
    
    func backgroundSetGradients() {
        paletteItems = [
            .transparent,
            .gradient([.orange, .purple, .cyan], .zero, .zero),
            .gradient([.purple, .yellow], .zero, .zero),
            .gradient([.orange, .yellow], .zero, .zero),
            .gradient([.white, .yellow], .zero, .zero),
            .gradient([.blue, .black], .zero, .zero),
            .gradient([.white, .black], .zero, .zero),
            .gradient([.blue, .orange], .zero, .zero),
            .gradient([.blue, .cyan], .zero, .zero),
            .gradient([.magenta, .cyan], .zero, .zero),
        ]
        reloadData()
    }
    
    func backgroundSetPastel() {
        paletteItems = [
            .transparent,
            .gradient(
                [UIColor(red: 0.769, green: 0.91, blue: 0.988, alpha: 1),
                 UIColor(red: 0.969, green: 0.82, blue: 0.945, alpha: 1)], .zero, .zero),
            .gradient(
                [UIColor(red: 0.976, green: 0.812, blue: 0.776, alpha: 1),
                 UIColor(red: 0.631, green: 0.561, blue: 0.812, alpha: 1)], .zero, .zero),
            .gradient(
                [UIColor(red: 0.98, green: 0.616, blue: 0.624, alpha: 1),
                 UIColor(red: 0.969, green: 0.82, blue: 0.945, alpha: 1)], .zero, .zero),
            .gradient(
                [UIColor(red: 0.475, green: 0.847, blue: 0.725, alpha: 1),
                 UIColor(red: 0.969, green: 0.82, blue: 0.945, alpha: 1)], .zero, .zero),
            .gradient(
                [UIColor(red: 0.69, green: 0.859, blue: 0.929, alpha: 1),
                 UIColor(red: 0.969, green: 0.82, blue: 0.945, alpha: 1)], .zero, .zero),
            
        ]
        reloadData()
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
