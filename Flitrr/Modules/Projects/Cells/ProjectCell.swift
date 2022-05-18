//
//  ProjectCell.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 15.05.2022.
//

import UIKit

final class ProjectCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var label: UILabel!
    
    var project: Project!
    
    private var heartButton: UIButton!
    
    var allowsFavoritesEditing = true
    
    var isChecked = false {
        didSet {
            layer.borderWidth = isChecked ? 1 : 0
            layer.borderColor = isChecked ? UIColor.appAccent.cgColor : UIColor.clear.cgColor
        }
    }
    
    var isFavorite: Bool = false {
        didSet {
            heartButton.setImage(UIImage(systemName: project.isFavorite ? "heart.fill" : "heart"), for: .normal)
        }
    }
    
    func set(_ project: Project) {
        self.project = project
        if let data = project.getPNGData() {
            imageView.image = UIImage(data: data)
            imageView.isHidden = false
            label.isHidden = true
        } else {
            label.text = project.id?.uuidString ?? ""
            imageView.isHidden = true
            label.isHidden = false
        }
        isChecked = project.isSelected
        isFavorite = project.isFavorite
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        addSubview(label)
        
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        layer.cornerCurve = .continuous
        clipsToBounds = true

        heartButton = UIButton()
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        heartButton.addTarget(self, action: #selector(handleFavoritesAction), for: .touchUpInside)
        heartButton.tintColor = .appAccent
        addSubview(heartButton)
    }
    
    @objc private func handleFavoritesAction() {
        guard allowsFavoritesEditing else {
            return
        }
        project.toggleIsFavorites()
        heartButton.setImage(UIImage(systemName: project.isFavorite ? "heart.fill" : "heart"), for: .normal)
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        imageView.frame = bounds
        heartButton.frame = .init(x: bounds.width - 40, y: 0, width: 40, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
