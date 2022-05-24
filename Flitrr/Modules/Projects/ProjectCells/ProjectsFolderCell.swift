//
//  ProjectsFolderCell.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 19.04.2022.
//

import UIKit

final class ProjectsFolderCell: UICollectionViewCell {
    
    var iconImageView: UIImageView!
    var imageView: UIImageView!
    var folderNameLabel: UILabel!
    var folderCountLabel: UILabel!
    
    var isChecked = false {
        didSet {
            if isChecked {
                imageView.layer.borderColor = UIColor.appAccent.cgColor
                imageView.layer.borderWidth = 1
            } else {
                imageView.layer.borderColor = UIColor.clear.cgColor
                imageView.layer.borderWidth = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.backgroundColor = .appGray
        imageView.layer.cornerRadius = 10
        imageView.layer.cornerCurve = .continuous
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        folderNameLabel = UILabel()
        folderNameLabel.textAlignment = .left
        folderNameLabel.text = "Summer Time"
        folderNameLabel.textColor = .label
        folderNameLabel.font = UIFont(name: "Montserrat-Regular", size: 15)
        addSubview(folderNameLabel)
        
        folderCountLabel = UILabel()
        folderCountLabel.textAlignment = .left
        folderCountLabel.text = "0"
        folderCountLabel.textColor = .gray
        folderCountLabel.font = UIFont(name: "Monserrat-Regular", size: 15)
        addSubview(folderCountLabel)
        
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame.size = .init(width: 30, height: 30)
        addSubview(iconImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = .init(x: 0, y: 0, width: bounds.width, height: bounds.height - 60)
        folderNameLabel.frame = .init(x: 0, y: bounds.height - 60, width: bounds.width, height: 30)
        folderCountLabel.frame = .init(x: 0, y: bounds.height - 30, width: bounds.width, height: 30)
        iconImageView.center = .init(x: bounds.midX, y: imageView.bounds.midY)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFolder(_ folder: FolderProtocol) {
        
        folderNameLabel.text = folder.name
        folderCountLabel.isHidden = false
        
        if folder.isForFavorites {
            iconImageView.isHidden = false
            iconImageView.image = UIImage(named: "FavoriteHeart")
            if let imageData = Project.getLastFavoriteProject()?.getPNGData() {
                imageView.image = UIImage(data: imageData)
            }
            return
        }
        if folder.isForCreation {
            iconImageView.isHidden = false
            iconImageView.image = UIImage(systemName: "plus")
            iconImageView.tintColor = .gray
            folderCountLabel.isHidden = true
            imageView.image = nil
            return
        }
        iconImageView.isHidden = true
        
        let projects = (folder as! Folder).getProjects()
        folderCountLabel.text = "\(projects.count)"
        
        if let last = projects.last {
            if let data = last.getPNGData() {
                imageView.image = UIImage(data: data)
            }
        }
    }

}
