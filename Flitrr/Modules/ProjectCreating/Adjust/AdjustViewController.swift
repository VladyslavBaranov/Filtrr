//
//  AdjustViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 20.05.2022.
//

import UIKit

protocol AdjustViewControllerDelegate: AnyObject {
    func didDismissAdjustController()
    func didReportValue(_ value: Float, option: AdjustViewController.Option)
    func shouldRemoveBackground()
}

final class AdjustViewController: UIViewController {
    
    enum Option { case none, contrast, saturation, brightness }
    struct AdjustmentItem {
        var title: String
        var option: Option
    }
    
    private var selectedOptionIndex = 0
    private var addedCount = 0
    
    var items: [AdjustmentItem] = [
        .init(title: LocalizationManager.shared.localizedString(for: .adjustNoBg), option: .none),
        .init(title: LocalizationManager.shared.localizedString(for: .adjustContrast), option: .contrast),
        .init(title: LocalizationManager.shared.localizedString(for: .adjustSaturation), option: .saturation),
        .init(title: LocalizationManager.shared.localizedString(for: .adjustBrightness), option: .brightness)
    ]
    
    weak var delegate: AdjustViewControllerDelegate!
    private var toolBarView: ToolBarView!
    
    private var sliderContainerView: CustomSliderContainerView!
    
    private var shadowOptionPicker: ValuePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appGray
        setupToolBar()
        setupOptionsPicker()
        setupSlider()
        
        shadowOptionPicker.selectedIndex = 1
        didSelectValue(at: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shadowOptionPicker.frame = .init(
            x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80)
    }

    private func setupSlider() {
        sliderContainerView = CustomSliderContainerView(
            frame: .init(origin: .zero, size: .init(width: view.bounds.width - 60, height: 30)))
        sliderContainerView.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        sliderContainerView.translatesAutoresizingMaskIntoConstraints = false
        sliderContainerView.isContinuous = false
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
        toolBarView.title = "Contrast"
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
        shadowOptionPicker.titles = items.map { $0.title }
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        delegate?.didReportValue(sender.value, option: items[selectedOptionIndex].option)
    }
}

extension AdjustViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        //delegate?.didDismissShadowController()
        dismiss(animated: true)
    }
    func didTapLeadingItem() {
        //delegate?.didDismissShadowController()
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}

extension AdjustViewController: ValuePickerViewDelegate {
    func didSelectValue(at index: Int) {
        selectedOptionIndex = index
        toolBarView.title = items[index].title
        if index == 0 {
            delegate?.shouldRemoveBackground()
        }
    }
}

extension AdjustViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FractionPresentationController(presentedViewController: presented, presenting: presenting, heightFactor: 0.3)
    }
}
