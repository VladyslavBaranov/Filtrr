//
//  HorizontalCollectionView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 25.04.2022.
//

import UIKit

final class ImageTitleCell: UICollectionViewCell {
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        addSubview(imageView)
        label = UILabel()
        label.font = Montserrat.regular(size: 10)
        label.textColor = .white
        label.text = "CATS"
        label.backgroundColor = .appGray
        label.textAlignment = .center
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .red
        
        imageView.backgroundColor = .orange
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class HorizontalCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(ImageTitleCell.self, forCellWithReuseIdentifier: "id")
        contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HorizontalCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath)
        return cell
    }
}

extension HorizontalCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.height, height: collectionView.bounds.height * 1.2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
