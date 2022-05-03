//
//  ProjectCreatingViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.04.2022.
//

import UIKit

final class ProjectCreatingViewController: UIViewController {
    
    var toolBarView: ToolBarView!
    var scrollableTabBar: ScrollableRoundedBar!
    var transparentGridView: ProjectTransparentGridView!
	
	var addedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appDark
        
        setupToolBar()
        transparentGridView = ProjectTransparentGridView()
		transparentGridView.clipsToBounds = true
        transparentGridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(transparentGridView)
        
        NSLayoutConstraint.activate([
            transparentGridView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
            transparentGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transparentGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transparentGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120)
        ])
        
        scrollableTabBar = ScrollableRoundedBar(frame: .init(
            x: 0,
            y: view.bounds.height - 80,
            width: view.bounds.width,
            height: 80)
        )
		scrollableTabBar.delegate = self
        scrollableTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollableTabBar)
        
        NSLayoutConstraint.activate([
            scrollableTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollableTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollableTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollableTabBar.heightAnchor.constraint(equalToConstant: 100)
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
		let renderer = UIGraphicsImageRenderer(size: transparentGridView.bounds.size)
		let image = renderer.image { ctx in
			transparentGridView.drawHierarchy(in: transparentGridView.bounds, afterScreenUpdates: true)
		}
		let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		present(activityController, animated: true, completion: nil)
    }
    func didTapLeadingItem() {
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}

extension ProjectCreatingViewController: ScrollableRoundedBarDelegate {
	func didTapItem(itemType: ScrollabelRoundedBarItemView.ItemType) {
		switch itemType {
		case .image:
			let controller = ImageLibraryPickerViewController.createInstance()
			controller.delegate = self
			controller.modalPresentationStyle = .fullScreen
			present(controller, animated: true)
		case .text:
			let controller = TextEditingViewController()
			controller.modalPresentationStyle = .fullScreen
			present(controller, animated: true, completion: nil)
		default:
			break
		}
	}
}

extension ProjectCreatingViewController: ImageLibraryPickerViewControllerDelegate {
	func didSelectImage(uiImage: UIImage) {
		
		addedCount += 1
		
		if addedCount == 2 {
			let v = AdjustableView(frame: .init(x: 15, y: 15, width: 200, height: 300))
			v.imageView.image = uiImage //.applyingFilter(name: "CIColorControls", parameters: ["inputContrast":10])
			transparentGridView.addSubview(v)
			addedCount = 0
		}
		
	}
}
