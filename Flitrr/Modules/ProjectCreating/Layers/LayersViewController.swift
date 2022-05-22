//
//  LayersViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 15.05.2022.
//

import UIKit

protocol LayersViewControllerDelegate: AnyObject {
    func didDismissLayers()
}

final class LayersViewController: UIViewController {
    
    weak var delegate: LayersViewControllerDelegate!
    
    private var currentlySelectedLayer: AdjustableView!
    
    var layers: [AdjustableView] = []
    private var layersCollectionView: LayersCollectionView!
    private var layerOptionsPicker: ValuePickerView!
    private var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appGray
        setupOptionsPicker()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layersCollectionView = LayersCollectionView(frame: .zero, collectionViewLayout: layout)
        layersCollectionView.layersDelegate = self
        layersCollectionView.layers = layers
        view.addSubview(layersCollectionView)
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipeGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layersCollectionView.frame = .init(x: 0, y: 30, width: view.bounds.width, height: view.bounds.height - 130)
        layerOptionsPicker.frame = .init(
            x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80)
    }
    
    func setupOptionsPicker() {
        layerOptionsPicker = ValuePickerView(
            frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
        layerOptionsPicker.titles = [
            LocalizationManager.shared.localizedString(for: .layersHide),
            LocalizationManager.shared.localizedString(for: .layersLock),
            LocalizationManager.shared.localizedString(for: .layersDelete)
        ]
        layerOptionsPicker.delegate = self
        view.addSubview(layerOptionsPicker)
    }
    
    @objc func swipeDown() {
        delegate?.didDismissLayers()
        dismiss(animated: true)
    }
}

extension LayersViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        delegate?.didDismissLayers()
        dismiss(animated: true)
    }
    func didTapLeadingItem() {
        delegate?.didDismissLayers()
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}

extension LayersViewController: ValuePickerViewDelegate {
    func didSelectValue(at index: Int) {
        guard let currentlySelectedLayer = currentlySelectedLayer else { return }
        switch index {
        case 0:
            currentlySelectedLayer.isHidden.toggle()
        case 1:
            currentlySelectedLayer.isTransformingEnabled.toggle()
        case 2:
            currentlySelectedLayer.isDeleted = true
        default:
            break
        }
    }
}

extension LayersViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FractionPresentationController(presentedViewController: presented, presenting: presenting, heightFactor: 0.3)
    }
}

extension LayersViewController: LayersCollectionViewDelegate {
    func didSelect(_ adjustable: AdjustableView) {
        currentlySelectedLayer = adjustable
    }
}

