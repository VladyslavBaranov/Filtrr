//
//  RoundedTabBarItems.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 19.04.2022.
//

import UIKit

protocol RoundedTabBarItemProtocol {
    func setSelected()
    func setUnselected()
    func getTag() -> Int
}

protocol TabBarItemDelegate: AnyObject {
    func didTap(_ tag: Int)
}

final class CirclePlusTabBarItem: UIView, RoundedTabBarItemProtocol {
    
    weak var delegate: TabBarItemDelegate!
    var circleView: UIView!
    var iconImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconImageView = UIImageView(image: UIImage(systemName: "plus"))
        iconImageView.tintColor = .gray
        iconImageView.isUserInteractionEnabled = true
        
        circleView = UIView()
        addSubview(circleView)
        addSubview(iconImageView)
        circleView.layer.cornerRadius = 30
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTap(tag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.center = .init(x: bounds.midX, y: bounds.midY)
        circleView.frame.size = .init(width: 60, height: 60)
        iconImageView.center = .init(x: bounds.midX, y: bounds.midY)
        iconImageView.frame.size = .init(width: 25, height: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSelected() {
    }
    func setUnselected() {
    }
    func getTag() -> Int {
        tag
    }
}

final class RoundedTabBarItem: UIView, RoundedTabBarItemProtocol {
    enum Style {
        case image, imageTitle
    }
    
    weak var delegate: TabBarItemDelegate!
    var iconImageView: UIImageView!

    var label: UILabel!
    
    var selectedImage: UIImage! {
        didSet {
            iconImageView.image = selectedImage
        }
    }
    var unselectedImage: UIImage!
    
    var style: Style = .imageTitle
    
    convenience init(style: Style) {
        self.init(frame: .zero)
        self.style = style
        
        var arrangedSubviews: [UIView] = []
        iconImageView = UIImageView(image: UIImage(named: "Grid"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isUserInteractionEnabled = true
        iconImageView.tintColor = .white
        arrangedSubviews.append(iconImageView)
        
        if style == .imageTitle {
            label = UILabel()
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 10)
            label.text = "IMAGE"
            label.textColor = .gray
            arrangedSubviews.append(label)
        }

        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(stackView, at: 0)
        stackView.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTap(tag)
    }
    func setSelected() {
        iconImageView.image = selectedImage
    }
    func setUnselected() {
        iconImageView.image = unselectedImage
    }
    func getTag() -> Int {
        tag
    }
}
