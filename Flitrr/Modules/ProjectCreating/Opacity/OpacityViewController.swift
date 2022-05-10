//
//  OpacityViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 10.05.2022.
//

import UIKit

protocol OpacityViewControllerDelegate: AnyObject {
    func didSetOpacity(_ opacity: Float)
    func didDismissOpacityController()
}

final class OpacityViewController: UIViewController {
    
    var originalOpacity: Float = 0.5
    weak var delegate: OpacityViewControllerDelegate!
    private var toolBarView: ToolBarView!
    
    private var opacityContainerView: CustomSliderContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appGray
        setupToolBar()
        setupSlider()
    }
    
    private func setupSlider() {
        
        opacityContainerView = CustomSliderContainerView(frame: .zero)
        opacityContainerView.slider.value = originalOpacity
        opacityContainerView.slider.addTarget(self, action: #selector(opacityDidChange(_:)), for: .valueChanged)
        opacityContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(opacityContainerView)
        
        NSLayoutConstraint.activate([
            opacityContainerView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
            opacityContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            opacityContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            opacityContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func opacityDidChange(_ sender: UISlider) {
        let opacity = sender.value
        toolBarView.title = "Opacity %\(Int(opacity * 100))"
        delegate?.didSetOpacity(opacity)
    }
    
    private func setupToolBar() {
        toolBarView = ToolBarView(frame: .zero, centerItem: .title)
        toolBarView.leadingItem = .cancel
        toolBarView.trailingItem = .confirm
        toolBarView.title = "Opacity %\(Int(originalOpacity * 100))"
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
}

extension OpacityViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        delegate?.didDismissOpacityController()
        dismiss(animated: true)
    }
    func didTapLeadingItem() {
        delegate?.didSetOpacity(originalOpacity)
        delegate?.didDismissOpacityController()
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}

extension OpacityViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FractionPresentationController(presentedViewController: presented, presenting: presenting, heightFactor: 0.3)
    }
}
