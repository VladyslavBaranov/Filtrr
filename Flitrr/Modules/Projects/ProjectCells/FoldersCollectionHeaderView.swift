//
//  FoldersCollectionHeaderView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 24.04.2022.
//

import UIKit

final class FoldersCollectionHeaderView: UICollectionReusableView {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }

    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
        titleLabel.text = "My Folders"
        titleLabel.font = Montserrat.medium(size: 17)
        titleLabel.sizeToFit()
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame.origin = .init(
            x: (bounds.maxY - titleLabel.bounds.height) / 2,
            y: bounds.maxY - titleLabel.bounds.height
        )
    }
}

