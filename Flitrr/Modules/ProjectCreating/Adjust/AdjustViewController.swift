//
//  AdjustViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 20.05.2022.
//

import UIKit

protocol AdjustViewControllerDelegate: AnyObject {
    func didDismissAdjustController()
    func didReport()
}

final class AdjustViewController: UIViewController {
    
    private var selectedOptionIndex = 0
    private var addedCount = 0
    private let titles = [
        "No Background", "Contrast", "Saturation", "Brightness", "Warmth"
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
        shadowOptionPicker.titles = titles
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
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
        toolBarView.title = titles[index]
        delegate?.didReport()
    }
}

extension AdjustViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FractionPresentationController(presentedViewController: presented, presenting: presenting, heightFactor: 0.3)
    }
}
