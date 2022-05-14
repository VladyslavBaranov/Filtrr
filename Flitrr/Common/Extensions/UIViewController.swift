//
//  UIViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 19.04.2022.
//

import UIKit

extension UIViewController {
    func createSection(cellsPerRow: Int, heightRatio: CGFloat, inset: CGFloat, usesHorizontalScroll: Bool) -> NSCollectionLayoutSection {
        
        let fraction: CGFloat = 1 / CGFloat(cellsPerRow)
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction * heightRatio))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction * heightRatio))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        if usesHorizontalScroll {
            section.orthogonalScrollingBehavior = .continuous
        }
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
    
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        return section
    }

    func createLayout(cellsPerRow: Int, heightRatio: CGFloat, inset: CGFloat, usesHorizontalScroll: Bool) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            return createSection(cellsPerRow: cellsPerRow, heightRatio: heightRatio, inset: inset, usesHorizontalScroll: usesHorizontalScroll)
        }
        return layout
    }

}


