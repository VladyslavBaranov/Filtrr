//
//  ProjectCell.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 15.05.2022.
//

import UIKit

final class ProjectCell: UICollectionViewCell {
    
    var label: UILabel!
    
    var project: Project!
    
    private var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
    var isChecked = false {
        didSet {
            layer.borderWidth = isChecked ? 1 : 0
            layer.borderColor = isChecked ? UIColor.appAccent.cgColor : UIColor.clear.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        addSubview(label)
        
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    @objc private func handleDoubleTap() {
        project.toggleIsFavorites()
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
