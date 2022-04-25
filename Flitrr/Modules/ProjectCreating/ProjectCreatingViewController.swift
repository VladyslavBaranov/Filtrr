//
//  ProjectCreatingViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.04.2022.
//

import UIKit

final class ProjectCreatingViewController: UIViewController {
    
    var toolBarView: ToolBarView!
    var scrollbaleTabBar: ScrollableRoundedBar!
    var transparentGridView: ProjectTransparentGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appDark
        
        setupToolBar()
        transparentGridView = ProjectTransparentGridView()
        transparentGridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(transparentGridView)
        
        NSLayoutConstraint.activate([
            transparentGridView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
            transparentGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transparentGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transparentGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120)
        ])
        
        scrollbaleTabBar = ScrollableRoundedBar(frame: .init(
            x: 0,
            y: view.bounds.height - 80,
            width: view.bounds.width,
            height: 80)
        )
        scrollbaleTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollbaleTabBar)
        
        NSLayoutConstraint.activate([
            scrollbaleTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollbaleTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollbaleTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollbaleTabBar.heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
    func setupToolBar() {
        toolBarView = ToolBarView(frame: .zero, centerItem: .editSet)
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

extension ProjectCreatingViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        let controller = ImageLibraryPickerViewController.createInstance()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    func didTapLeadingItem() {
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}
