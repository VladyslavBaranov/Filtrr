//
//  RoundedTabBar.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.04.2022.
//

import UIKit

protocol RoundedTabBarDelegate: AnyObject {
    func didTapItem(_ tag: Int)
}

final class RoundedTabBar: UIView {
    
    weak var delegate: RoundedTabBarDelegate!
    
    var tabBarItems: [RoundedTabBarItemProtocol] = []

    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appGray
        
        let item1 = RoundedTabBarItem(style: .image)
        item1.selectedImage = UIImage(named: "Grid")
        item1.unselectedImage = UIImage(named: "GridUnselected")
        item1.tag = 0
        let item2 = CirclePlusTabBarItem(frame: .zero)
        item2.tag = 1
        let item3 = RoundedTabBarItem(style: .image)
        item3.tag = 2
        item3.selectedImage = UIImage(named: "Profile")
        item3.unselectedImage = UIImage(named: "ProfileUnselected")
        
        tabBarItems = [item1, item2, item3]
        stackView = UIStackView(arrangedSubviews: [item1, item2, item3])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        item1.delegate = self
        item2.delegate = self
        item3.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let roundedLayer = CAShapeLayer()
        roundedLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: .init(width: 15, height: 15)
        ).cgPath
        layer.mask = roundedLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RoundedTabBar: TabBarItemDelegate {
    func didTap(_ tag: Int) {
        for item in tabBarItems {
            item.getTag() == tag ? item.setSelected() : item.setUnselected()
        }
        delegate?.didTapItem(tag)
    }
}
