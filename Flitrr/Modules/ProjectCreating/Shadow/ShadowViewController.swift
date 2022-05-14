//
//  ShadowViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 10.05.2022.
//


/*
 y = -50cosx
 x = 50sinx
 */

import UIKit

final class ShadowModel {
    var size: CGFloat = 0.0
    var angle: CGSize = .init(width: 0, height: 0)
    var blur: CGFloat = 0.0
    var color: CGColor = UIColor.black.cgColor
    var alpha: Float = 0.0
    var _angle: CGFloat = 0.0
    
    init(layer: CALayer) {
        size = max(abs(layer.shadowOffset.width), abs(layer.shadowOffset.height))
        angle = layer.shadowOffset
        blur = layer.shadowRadius
        color = layer.shadowColor ?? UIColor.clear.cgColor
        alpha = layer.shadowOpacity
    }
    
    init() {}
    
    func copy() -> ShadowModel {
        let model = ShadowModel()
        model.size = size
        model.angle = angle
        model.blur = blur
        model.alpha = alpha
        if let colorCopy = color.copy() {
            model.color = colorCopy
        }
        return model
    }
}

protocol ShadowViewControllerDelegate: AnyObject {
    func didDismissShadowController()
    func didReportNewShadowModel(_ model: ShadowModel)
}

final class ShadowViewController: UIViewController {
    
    var originalShadowModel: ShadowModel!
    var modelCopy: ShadowModel!
    
    private var selectedOptionIndex = 0
    private var addedCount = 0
    private let titles = [
        LocalizationManager.shared.localizedString(for: .shadowSize),
        LocalizationManager.shared.localizedString(for: .shadowAngle),
        LocalizationManager.shared.localizedString(for: .shadowBlur),
        LocalizationManager.shared.localizedString(for: .textColor),
        LocalizationManager.shared.localizedString(for: .shadowOpacity)
    ]
    
    weak var delegate: ShadowViewControllerDelegate!
    private var toolBarView: ToolBarView!
    
    private var sliderContainerView: CustomSliderContainerView!
    private var palette: ColorPaletteCollectionView!
    
    private var shadowOptionPicker: ValuePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelCopy = originalShadowModel.copy()
        
        view.backgroundColor = .appGray
        setupToolBar()
        setupOptionsPicker()
        setupSlider()
        setupPalette()
        
        sliderContainerView.isHidden = false
        palette.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowOptionPicker.frame = .init(
            x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80)
        palette.frame = .init(x: 0, y: 80, width: view.bounds.width, height: 90)
    }
    
    private func setupPalette() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        palette = ColorPaletteCollectionView(
            frame: .init(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height - 160), collectionViewLayout: layout
        )
        setupColors()
        palette.paletteDelegate = self
        view.addSubview(palette)
    }
    
    private func setupSlider() {
        sliderContainerView = CustomSliderContainerView(frame: .zero)
        sliderContainerView.translatesAutoresizingMaskIntoConstraints = false
        sliderContainerView.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        view.addSubview(sliderContainerView)
        
        NSLayoutConstraint.activate([
            sliderContainerView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
            sliderContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            sliderContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            sliderContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
    
    func setupToolBar() {
        toolBarView = ToolBarView(frame: .zero, centerItem: .title)
        toolBarView.leadingItem = .cancel
        toolBarView.trailingItem = .confirm
        toolBarView.title = LocalizationManager.shared.localizedString(for: .shadowSize)
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
    
    func setupOptionsPicker() {
        shadowOptionPicker = ValuePickerView(
            frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
        shadowOptionPicker.delegate = self
        view.addSubview(shadowOptionPicker)
        shadowOptionPicker.titles = titles
        shadowOptionPicker.selectedIndex = 0
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        switch selectedOptionIndex {
        case 0:
            let size = CGFloat(sender.value) * 100
            print(size)
            modelCopy.size = size
            let rad = modelCopy._angle
            let newAngle = CGSize(width: size * sin(rad), height: -size * cos(rad))
            modelCopy.angle = newAngle
            delegate?.didReportNewShadowModel(modelCopy)
        case 1:
            let rad = CGFloat(2 * sender.value * .pi)
            modelCopy._angle = rad
            let ssize = modelCopy.size
            let size = CGSize(width: ssize * sin(rad), height: -ssize * cos(rad))
            modelCopy.angle = size
            delegate?.didReportNewShadowModel(modelCopy)
            toolBarView.title = "\(LocalizationManager.shared.localizedString(for: .shadowAngle)) \(Int(sender.value * 360))°"
        case 2:
            modelCopy.blur = CGFloat(sender.value) * 100
            delegate?.didReportNewShadowModel(modelCopy)
            toolBarView.title = "\(LocalizationManager.shared.localizedString(for: .shadowBlur)) \(Int(modelCopy.blur))"
        case 4:
            modelCopy.alpha = sender.value
            delegate?.didReportNewShadowModel(modelCopy)
            toolBarView.title = "\(LocalizationManager.shared.localizedString(for: .shadowOpacity)) %\(Int(sender.value * 100))"
        default:
            break
        }
    }
    
    func setupColors() {
        palette.paletteItems = [
            .color(.appAccent),
            .color(UIColor(red: 1, green: 0.02, blue: 0.5, alpha: 1)),
            .color(UIColor(red: 0.761, green: 0.09, blue: 0.49, alpha: 1)),
            .color(UIColor(red: 0.38, green: 0.102, blue: 0.784, alpha: 1)),
            .color(UIColor(red: 0.29, green: 0.384, blue: 0.851, alpha: 1)),
            .color(UIColor(red: 0, green: 0.471, blue: 0.565, alpha: 1)),
            .color(.white), .color(.black),
            .color(UIColor(red: 1, green: 0.02, blue: 0.4, alpha: 1)),
            .color(UIColor(red: 0.761, green: 0.09, blue: 0.49, alpha: 1)),
            .color(UIColor.darkGray),
            .color(UIColor.gray),
            .color(.lightGray),
            .color(.red),
            .color(.orange),
            .color(.yellow),
            .color(.green),
            .color(.cyan),
            .color(.blue),
            .color(.purple)
        ]
    }
}

extension ShadowViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        delegate?.didDismissShadowController()
        dismiss(animated: true)
    }
    func didTapLeadingItem() {
        delegate?.didReportNewShadowModel(originalShadowModel)
        delegate?.didDismissShadowController()
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}

extension ShadowViewController: ValuePickerViewDelegate {
    func didSelectValue(at index: Int) {
        selectedOptionIndex = index
        switch index {
        case 0:
            sliderContainerView.isHidden = false
            palette.isHidden = true
            toolBarView.title = LocalizationManager.shared.localizedString(for: .shadowSize)
            sliderContainerView.slider.value = Float(modelCopy.size / 100)
        case 1:
            sliderContainerView.isHidden = false
            palette.isHidden = true
            toolBarView.title = LocalizationManager.shared.localizedString(for: .shadowAngle)
            sliderContainerView.slider.value = Float(modelCopy._angle / (2 * .pi))
        case 2:
            sliderContainerView.isHidden = false
            palette.isHidden = true
            toolBarView.title = LocalizationManager.shared.localizedString(for: .shadowBlur)
            sliderContainerView.slider.value = Float(modelCopy.blur / 100)
        case 3:
            sliderContainerView.isHidden = true
            palette.isHidden = false
            toolBarView.title = LocalizationManager.shared.localizedString(for: .textColor)
        case 4:
            sliderContainerView.isHidden = false
            palette.isHidden = true
            toolBarView.title = LocalizationManager.shared.localizedString(for: .shadowOpacity)
            sliderContainerView.slider.value = modelCopy.alpha
        default:
            break
        }
    }
}

extension ShadowViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FractionPresentationController(presentedViewController: presented, presenting: presenting, heightFactor: 0.3)
    }
}

extension ShadowViewController: ColorPaletteCollectionViewDelegate {
    func didSelectItem(_ item: ColorPaletteItem) {
        switch item {
        case .fill:
            break
        case .textColor:
            break
        case .picker:
            break
        case .color(let uIColor):
            modelCopy.color = uIColor.cgColor
            delegate?.didReportNewShadowModel(modelCopy)
        default:
            break
        }
    }
}
