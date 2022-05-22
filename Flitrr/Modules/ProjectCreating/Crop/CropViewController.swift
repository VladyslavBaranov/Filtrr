//
//  CropViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 11.05.2022.
//

import UIKit

protocol CropViewControllerDelegate: AnyObject {
    func didCut(_ image: UIImage)
}

final class CropViewController: UIViewController {
    
    weak var delegate: CropViewControllerDelegate!
    var originalImage: UIImage!
    private var toolBarView: ToolBarView!
    private var adjustableView: AdjustableImageView!
    private var cropOptionPicker: ValuePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appDark
        setupToolBar()
        setupCropPicker()
        
        adjustableView = AdjustableImageView(frame: .zero)
        adjustableView.originalImage = originalImage
        adjustableView.imageView.image = originalImage
        adjustableView.isTransformingEnabled = false
        view.addSubview(adjustableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let targetWidth = view.bounds.width - 60
        let imageWidth = originalImage.size.width
        let imageHeight = originalImage.size.height
        let targetHeight = imageHeight * (targetWidth / imageWidth)
        
        let maxHeight = view.bounds.height - (view.safeAreaInsets.top + 160)
        
        if targetHeight > maxHeight {
            let targetWidth = imageWidth * (maxHeight / imageHeight)
            adjustableView.frame = .init(
                x: (view.bounds.width - targetWidth) / 2,
                y: toolBarView.frame.maxY,
                width: targetWidth,
                height: maxHeight
            )
        } else {
            adjustableView.frame = .init(x: 30, y: toolBarView.frame.maxY, width: targetWidth, height: targetHeight)
        }
    }
    
    func setupToolBar() {
        toolBarView = ToolBarView(frame: .zero, centerItem: .title)
        toolBarView.leadingItem = .cancel
        toolBarView.trailingItem = .confirm
        toolBarView.title = LocalizationManager.shared.localizedString(for: .cropTitle)
        toolBarView.delegate = self
        toolBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBarView)
        
        NSLayoutConstraint.activate([
            toolBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBarView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupCropPicker() {
        cropOptionPicker = ValuePickerView(
            frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
        cropOptionPicker.isTransparentAppearance = true
        cropOptionPicker.titles = [
            LocalizationManager.shared.localizedString(for: .cropOriginal),
            LocalizationManager.shared.localizedString(for: .cropSquare),
            LocalizationManager.shared.localizedString(for: .cropCircle)
        ]
        cropOptionPicker.delegate = self
        view.addSubview(cropOptionPicker)
    }
}

extension CropViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        if let img = adjustableView.imageView.image {
            delegate?.didCut(img)
        }
        dismiss(animated: true)
    }
    func didTapLeadingItem() {
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}

extension CropViewController: ValuePickerViewDelegate {
    func didSelectValue(at index: Int) {
        let original = originalImage
        switch index {
        case 0:
            adjustableView.imageView.image = originalImage
        case 1:
            adjustableView.activityIndicator.startAnimating()
            DispatchQueue.global().async {
                let res = original?.squareCut()
                DispatchQueue.main.async { [unowned self] in
                    adjustableView.imageView.image = res
                    adjustableView.activityIndicator.stopAnimating()
                }
            }
        case 2:
            adjustableView.activityIndicator.startAnimating()
            DispatchQueue.global().async {
                let res = original?.circleCut()
                DispatchQueue.main.async { [unowned self] in
                    adjustableView.imageView.image = res
                    adjustableView.activityIndicator.stopAnimating()
                }
            }
        case 3:
            adjustableView.imageView.image = originalImage.proportionCut(x: 3, y: 4)
        case 4:
            adjustableView.imageView.image = originalImage.proportionCut(x: 4, y: 3)
        default:
            break
        }
    }
}
