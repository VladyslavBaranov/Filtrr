//
//  FiltersViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 09.05.2022.
//

import UIKit

struct BlendMode {
    var displayName: String
    var filterName: String
}

protocol FiltersViewControllerDelegate: AnyObject {
    func didDismissFilters()
    func didSelectBlendMode(_ filterName: String)
    func didSelectFilter(_ filter: Filter) 
}

final class FiltersViewController: UIViewController {
    
    private let loader = FilterLoader()
    
    private let blendModes: [BlendMode] = [
        .init(displayName: "Normal", filterName: "normalBlendMode"),
        .init(displayName: "Darken", filterName: "dakenBlendMode"),
        .init(displayName: "Multiply", filterName: "multiplyBlendMode"),
        .init(displayName: "Color Burn", filterName: "colorBurnBlendMode"),
        .init(displayName: "Lighten", filterName: "lightenBlendMode"),
        .init(displayName: "Difference", filterName: "differenceBlendMode"),
        .init(displayName: "Exclusion", filterName: "exclusionBlendMode"),
        .init(displayName: "Xor", filterName: "xorBlendMode"),
    ]
    
    var addedCount = 0
    var targetImage: UIImage!
    
    weak var delegate: FiltersViewControllerDelegate!
    
    private var filtersCollectionView: FiltersCollectionView!
    private var blendModePickerView: ValuePickerView!
    private var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appGray
        setupOptionsPicker()
        blendModePickerView.titles = blendModes.map { $0.displayName }
        
        blendModePickerView.selectedIndex = 0
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        filtersCollectionView = FiltersCollectionView(frame: .zero, collectionViewLayout: layout)
        filtersCollectionView.filteringDelegate = self
        filtersCollectionView.targetImage = targetImage
        filtersCollectionView.filters = loader.filters
        view.addSubview(filtersCollectionView)
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipeGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filtersCollectionView.frame = .init(x: 0, y: 30, width: view.bounds.width, height: view.bounds.height - 130)
        blendModePickerView.frame = .init(
            x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80)
    }
    
    func setupOptionsPicker() {
        blendModePickerView = ValuePickerView(
            frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
        blendModePickerView.delegate = self
        view.addSubview(blendModePickerView)
    }
    
    @objc func swipeDown() {
        delegate?.didDismissFilters()
        dismiss(animated: true)
    }
}

extension FiltersViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        delegate?.didDismissFilters()
        dismiss(animated: true)
    }
    func didTapLeadingItem() {
        delegate?.didDismissFilters()
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}

extension FiltersViewController: ValuePickerViewDelegate {
    func didSelectValue(at index: Int) {
        delegate?.didSelectBlendMode(blendModes[index].filterName)
    }
}

extension FiltersViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FractionPresentationController(presentedViewController: presented, presenting: presenting, heightFactor: 0.3)
    }
}

extension FiltersViewController: FiltersCollectionViewDelegate {
    func didSelect(_ filter: Filter) {
        delegate?.didSelectFilter(filter)
    }
}
