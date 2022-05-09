//
//  ProjectCreatingViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.04.2022.
//

import UIKit

final class ProjectCreatingViewController: UIViewController {
    
    private var currentlySelectedAdjustableView: AdjustableView!
    
    var toolBarView: ToolBarView!
    var scrollableTabBar: ScrollableRoundedBar!
    var transparentGridView: ProjectTransparentGridView!
	
	var addedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appDark
        
        setupToolBar()
        transparentGridView = ProjectTransparentGridView()
        transparentGridView.gridIsActive = false
        transparentGridView.isTransformingEnabled = false
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
        transparentGridView.untoggle()
        guard let png = transparentGridView.asPNG else { return }
		// let renderer = UIGraphicsImageRenderer(size: transparentGridView.bounds.size)
        //
		// let image = renderer.image { ctx in
		// 	transparentGridView.drawHierarchy(in: transparentGridView.bounds, afterScreenUpdates: true)
		// }
		let activityController = UIActivityViewController(activityItems: [png], applicationActivities: nil)
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
            controller.delegate = self
			controller.modalPresentationStyle = .fullScreen
			present(controller, animated: true, completion: nil)
        case .background:
            transparentGridView.gridIsActive = true
            toolBarView.centerItem = .title
            toolBarView.leadingItem = .none
            toolBarView.trailingItem = .none
            toolBarView.title = "Background"
            
            let vc = BackgroundSelectionViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = vc
            present(vc, animated: true, completion: nil)
            
            let baseHeight = transparentGridView.bounds.height
            let topHeight = view.safeAreaInsets.top + 80
            let vcHeight = view.bounds.height * 0.3
            let destinationHeight = view.bounds.height - vcHeight - topHeight
            let factor = destinationHeight / baseHeight
            
            UIView.animate(withDuration: 0.3) {
                self.transparentGridView.transform = .init(scaleX: factor, y: factor)
                    .concatenating(.init(translationX: 0, y: -(baseHeight - baseHeight * factor) / 2))
            }
        case .filters:
            break
		default:
			break
		}
	}
}

extension ProjectCreatingViewController: ImageLibraryPickerViewControllerDelegate {
	func didSelectImage(uiImage: UIImage) {
		
		addedCount += 1
		
		if addedCount == 2 {
            let v = AdjustableImageView(frame:
                    .init(x: 0, y: 0, width: transparentGridView.bounds.midX, height: transparentGridView.bounds.midY))
            v.imageDelegate = self
			v.imageView.image = uiImage
			transparentGridView.add(v)
			addedCount = 0
		}
		
	}
}

extension ProjectCreatingViewController: ColorPickerViewControllerDelegate {
    func didDismissColorPicker() {
        toolBarView.centerItem = .editSet
        toolBarView.leadingItem = .back
        toolBarView.trailingItem = .share
        UIView.animate(withDuration: 0.3) {
            self.transparentGridView.transform = .identity
        }
    }
    
    func didReportColor(_ uiColor: UIColor) {
        toolBarView.centerItem = .editSet
        toolBarView.leadingItem = .back
        toolBarView.trailingItem = .share
        UIView.animate(withDuration: 0.3) {
            self.transparentGridView.transform = .identity
        }
    }
    
}

extension ProjectCreatingViewController: BackgroundSelectionViewControllerDelegate {
    func shouldFillWithImage(_ uiImage: UIImage) {
        transparentGridView.bakgroundMode = .image(uiImage)
    }
    
    func shouldFillBackgroundWithPlain(_ color: UIColor) {
        transparentGridView.bakgroundMode = .plainColor(color)
    }
    
    func didDismissBackgroundSelection() {
        transparentGridView.gridIsActive = false
        toolBarView.centerItem = .editSet
        toolBarView.leadingItem = .back
        toolBarView.trailingItem = .share
        UIView.animate(withDuration: 0.3) {
            self.transparentGridView.transform = .identity
        }
    }
}

extension ProjectCreatingViewController: TextEditingViewControllerDelegate {
    func didConfirmText(_ attributedString: NSAttributedString) {
        let label = AdjustableLabel.createLabel(for: attributedString)
        transparentGridView.add(label)
    }
}

extension ProjectCreatingViewController: AdjustableViewDelegate {
    func frameDidChange(_ view: AdjustableView) {
        // transparentGridView.setNeedsDisplay()
    }
    
    func didToggleFiltersMode(_ view: AdjustableView, _ isGridEnabled: Bool) {
        
        currentlySelectedAdjustableView = view
        
        toolBarView.leadingItem = .none
        toolBarView.trailingItem = .none
        toolBarView.centerItem = .title
        toolBarView.title = "Filters"
        
        let filtersController = FiltersViewController()
        if let imageView = view as? AdjustableImageView {
            
            if let img = imageView.imageView.image {
                let factor = 100 / img.size.width
                let renderer = UIGraphicsImageRenderer(size: .init(width: 100, height: img.size.height * factor))
                let scaledImage = renderer.image { _ in
                    img.draw(in: CGRect(origin: .zero, size: .init(width: 100, height: img.size.height * factor)))
                }
                filtersController.targetImage = scaledImage
            }
            
        }
        filtersController.delegate = self
        filtersController.modalPresentationStyle = .custom
        filtersController.transitioningDelegate = filtersController
        present(filtersController, animated: true, completion: nil)
        
        let baseHeight = transparentGridView.bounds.height
        let topHeight = self.view.safeAreaInsets.top + 80
        let vcHeight = self.view.bounds.height * 0.3
        let destinationHeight = self.view.bounds.height - vcHeight - topHeight
        let factor = destinationHeight / baseHeight
        
        UIView.animate(withDuration: 0.3) {
            self.transparentGridView.transform = .init(scaleX: factor, y: factor)
                .concatenating(.init(translationX: 0, y: -(baseHeight - baseHeight * factor) / 2))
        }
    }
}

extension ProjectCreatingViewController: AdjustableImageViewDelegate {
    func didToggleFilterMode(_ view: AdjustableImageView) {
        currentlySelectedAdjustableView = view
        
        toolBarView.leadingItem = .none
        toolBarView.trailingItem = .none
        toolBarView.centerItem = .title
        toolBarView.title = "Filters"
        
        let filtersController = FiltersViewController()
        if let imageView = view as? AdjustableImageView {
            
            if let img = imageView.imageView.image {
                let factor = 100 / img.size.width
                let renderer = UIGraphicsImageRenderer(size: .init(width: 100, height: img.size.height * factor))
                let scaledImage = renderer.image { _ in
                    img.draw(in: CGRect(origin: .zero, size: .init(width: 100, height: img.size.height * factor)))
                }
                filtersController.targetImage = scaledImage
            }
            
        }
        filtersController.delegate = self
        filtersController.modalPresentationStyle = .custom
        filtersController.transitioningDelegate = filtersController
        present(filtersController, animated: true, completion: nil)
        
        let baseHeight = transparentGridView.bounds.height
        let topHeight = self.view.safeAreaInsets.top + 80
        let vcHeight = self.view.bounds.height * 0.3
        let destinationHeight = self.view.bounds.height - vcHeight - topHeight
        let factor = destinationHeight / baseHeight
        
        UIView.animate(withDuration: 0.3) {
            self.transparentGridView.transform = .init(scaleX: factor, y: factor)
                .concatenating(.init(translationX: 0, y: -(baseHeight - baseHeight * factor) / 2))
        }
    }
}

extension ProjectCreatingViewController: FiltersViewControllerDelegate {
    func didSelectFilter(_ filter: Filter) {
        guard let imageAdjustableView = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        guard let img = imageAdjustableView.imageView.image else { return }
        guard let output = img.applyingFilter(name: filter.filterName, parameters: [:]) else { return }
        imageAdjustableView.imageView.image = output
    }
    
    func didSelectBlendMode(_ filterName: String) {
        currentlySelectedAdjustableView.layer.compositingFilter = filterName
    }
    
    func didDismissFilters() {
        toolBarView.leadingItem = .back
        toolBarView.trailingItem = .share
        toolBarView.centerItem = .editSet
        transparentGridView.gridIsActive = false
        toolBarView.centerItem = .editSet
        toolBarView.leadingItem = .back
        toolBarView.trailingItem = .share
        UIView.animate(withDuration: 0.3) {
            self.transparentGridView.transform = .identity
        }
    }
}
