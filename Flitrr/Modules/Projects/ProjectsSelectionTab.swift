//
//  ProjectsSelectionTab.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 19.04.2022.
//

import UIKit

protocol ProjectsSelectionTabDelegate: AnyObject {
    func didTapShare()
    func didTapTrash()
}

final class ProjectsSelectionTab: UIView {
    
    weak var delegate: ProjectsSelectionTabDelegate!
    
    private(set) var shareButton: UIButton!
    private var numberLabel: UILabel!
    private var deleteButton: UIButton!
    
    var title: String = "" {
        didSet {
            numberLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appGray
        shareButton = UIButton()
        shareButton.setImage(UIImage(named: "Share"), for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        addSubview(shareButton)
        
        numberLabel = UILabel()
        numberLabel.text = "0 Projects Selected"
        numberLabel.textColor = .label
        numberLabel.font = UIFont(name: "Montserrat-Regular", size: 15)
        numberLabel.textAlignment = .center
        addSubview(numberLabel)
        
        deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "Delete"), for: .normal)
        deleteButton.addTarget(self, action: #selector(didTapTrash), for: .touchUpInside)
        addSubview(deleteButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shareButton.frame = .init(x: 0, y: 0, width: bounds.height, height: bounds.height)
        deleteButton.frame = .init(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
        numberLabel.frame = .init(
            x: bounds.height, y: 0, width: bounds.width - 2 * bounds.height, height: bounds.height)
        let roundedLayer = CAShapeLayer()
        roundedLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: .init(width: 15, height: 15)
        ).cgPath
        layer.mask = roundedLayer
    }
    
    @objc private func didTapShare() {
        delegate?.didTapShare()
    }
    
    @objc private func didTapTrash() {
        delegate?.didTapTrash()
    }
}
