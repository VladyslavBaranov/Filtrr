//
//  ProjectCreatingViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.04.2022.
//

import UIKit

protocol ProjectCreatingViewControllerDelegate: AnyObject {
    func shouldReloadProjects()
}

final class ProjectCreatingViewController: UIViewController {
    
    weak var delegate: ProjectCreatingViewControllerDelegate!
    private var currentlySelectedAdjustableView: AdjustableView!
    
    var toolBarView: ToolBarView!
    var scrollableTabBar: ScrollableRoundedBar!
    var transparentGridView: ProjectTransparentGridView!
	
	var addedCount = 0
    
    private var initialBackgroundItem = ColorPaletteItem.transparent
    
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
    
    func prepareForOnThird(title: String) {
        transparentGridView.gridIsActive = true
        toolBarView.centerItem = .title
        toolBarView.leadingItem = .none
        toolBarView.trailingItem = .none
        toolBarView.title = title
        
        let baseHeight = transparentGridView.bounds.height
        let topHeight = view.safeAreaInsets.top + 80
        let vcHeight = view.bounds.height * 0.3
        let destinationHeight = view.bounds.height - vcHeight - topHeight
        let factor = destinationHeight / baseHeight
        
        UIView.animate(withDuration: 0.3) {
            self.transparentGridView.transform = .init(scaleX: factor, y: factor)
                .concatenating(.init(translationX: 0, y: -(baseHeight - baseHeight * factor) / 2))
        }
    }
    func prepareForFullFromOneThird() {
        transparentGridView.gridIsActive = false
        toolBarView.centerItem = .editSet
        toolBarView.leadingItem = .back
        toolBarView.trailingItem = .share
        UIView.animate(withDuration: 0.3) {
            self.transparentGridView.transform = .identity
        }
    }
}

extension ProjectCreatingViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        transparentGridView.untoggle()
        guard let png = transparentGridView.createPNG() else { return }
		// let renderer = UIGraphicsImageRenderer(size: transparentGridView.bounds.size)
        //
		// let image = renderer.image { ctx in
		// 	transparentGridView.drawHierarchy(in: transparentGridView.bounds, afterScreenUpdates: true)
		// }
		let activityController = UIActivityViewController(activityItems: [png], applicationActivities: nil)
        activityController.completionWithItemsHandler = nil
		present(activityController, animated: true, completion: nil)
    }
    
    func didTapLeadingItem() {
        
        let alert = UIAlertController(
            title: "New Project",
            message: "Warning: all layers will be merged upon saved",
            preferredStyle: .alert)
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { [unowned self] _ in
            dismiss(animated: true)
        }
        
        alert.addAction(discardAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(cancelAction)
        let saveAction = UIAlertAction(title: "Save", style: .cancel) { [unowned self] _ in
            guard let png = transparentGridView.createPNG() else { return }
            Project.createProjectAndSave(pngData: png)
            NotificationCenter.default.post(
                name: Notification.Name("shouldReloadProjectNotificationDidReceive"),
                object: nil
            )
            dismiss(animated: true)
            
        }
        
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    func didTapUndo() {
        guard let undoManager = undoManager else { return }
        guard undoManager.canUndo else { return }
        undoManager.undo()
    }
    
    func didTapLayers() {
        showLayersController()
    }
    
    func didTapRedo() {
        guard let undoManager = undoManager else { return }
        guard undoManager.canRedo else { return }
        undoManager.redo()
        print("REDONE")
    }
}

extension ProjectCreatingViewController: ScrollableRoundedBarDelegate {
	func didTapItem(itemType: CreatingOption) {
		switch itemType {
		case .image:
			showImagePicker()
		case .text:
			showTextEditing()
        case .graphic:
            let vc = GraphicViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .shape:
            showShapesController()
        case .background:
            showBackgroundController()
        case .filters:
            showFiltersController()
        case .crop:
            showCropViewController()
        case .shadow:
            showShadowViewController()
        case .opacity:
            showOpacityViewController()
		default:
			break
		}
	}
}

extension ProjectCreatingViewController: ImageLibraryPickerViewControllerDelegate {
    
    func showImagePicker() {
        let controller = ImageLibraryPickerViewController.createInstance()
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    func didSelectImage(uiImage: UIImage) {
        addedCount += 1
        guard addedCount == 2 else { return }
        let v = AdjustableImageView(frame:
                .init(x: 0, y: 0, width: transparentGridView.bounds.midX, height: transparentGridView.bounds.midY))
        v.originalImage = uiImage
        v.imageDelegate = self
        v.delegate = self
        transparentGridView.add(v)
        addedCount = 0
        
        undoManager?.registerUndo(withTarget: self, handler: { [unowned self] h in
            transparentGridView.remove(v)
        })
    }
}

extension ProjectCreatingViewController: ColorPickerViewControllerDelegate {
    func didDismissColorPicker() {
        prepareForFullFromOneThird()
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

extension ProjectCreatingViewController: TextEditingViewControllerDelegate {
    
    func showTextEditing() {
        let controller = TextEditingViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    func didConfirmText(_ attributedString: NSAttributedString) {
        let label = AdjustableLabel.createLabel(for: attributedString)
        transparentGridView.add(label)
        
        undoManager?.registerUndo(withTarget: self, handler: { [unowned self] _ in
            transparentGridView.remove(label)
        })
    }
}

extension ProjectCreatingViewController: ShapesViewControllerDelegate {
    func showShapesController() {
        let controller = ShapesViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    func didSelectBasicShape(_ name: String, size: CGSize) {
        let shape = AdjustableImageView(frame:
                .init(x: 0, y: 0, width: size.width, height: size.height))
        shape.imageDelegate = self
        shape.delegate = self
        shape.imageView.image = UIImage(named: name)
        transparentGridView.add(shape)
        
        undoManager?.registerUndo(withTarget: self, handler: { [unowned self] _ in
            transparentGridView.remove(shape)
        })
    }
}

extension ProjectCreatingViewController {
    func showCropViewController() {
        guard let adjustable = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        guard let image = adjustable.imageView.image else { return }
        let controller = CropViewController()
        controller.originalImage = image
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true)
    }
}

extension ProjectCreatingViewController: BackgroundSelectionViewControllerDelegate {
    func shouldFillWithGradient(_ paletteItem: ColorPaletteItem, _ colors: [UIColor]) {
        initialBackgroundItem = paletteItem
        transparentGridView.bakgroundMode = .gradient(colors)
    }
    
    func showBackgroundController() {
        prepareForOnThird(title: LocalizationManager.shared.localizedString(for: .backgroundTitle))
        let vc = BackgroundSelectionViewController()
        vc.initialPaletteItem = initialBackgroundItem
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        present(vc, animated: true, completion: nil)
    }
    
    func shouldFillWithImage(_ paletteItem: ColorPaletteItem, _ uiImage: UIImage) {
        initialBackgroundItem = paletteItem
        transparentGridView.bakgroundMode = .image(uiImage)
    }
    
    func shouldFillBackgroundWithPlain(_ paletteItem: ColorPaletteItem, _ color: UIColor) {
        initialBackgroundItem = paletteItem
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



extension ProjectCreatingViewController: AdjustableViewDelegate {
    
    func didToggle(_ view: AdjustableView) {
        currentlySelectedAdjustableView = view
    }
    
    func frameDidChange(_ view: AdjustableView) {
        // transparentGridView.setNeedsDisplay()
    }
}

extension ProjectCreatingViewController: AdjustableImageViewDelegate {
    
    func showFiltersController() {
        guard let adjustable = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        prepareForOnThird(title: LocalizationManager.shared.localizedString(for: .filtersTitle))
        let filtersController = FiltersViewController()
        if let img = adjustable.originalImage {
            let factor = 100 / img.size.width
            let renderer = UIGraphicsImageRenderer(size: .init(width: 100, height: img.size.height * factor))
            let scaledImage = renderer.image { _ in
                img.draw(in: CGRect(origin: .zero, size: .init(width: 100, height: img.size.height * factor)))
            }
            filtersController.targetImage = scaledImage
        }
        filtersController.modalPresentationStyle = .custom
        filtersController.delegate = self
        filtersController.transitioningDelegate = filtersController
        present(filtersController, animated: true, completion: nil)
    }
    
    func didToggleFilterMode(_ view: AdjustableImageView) {
    }
}

extension ProjectCreatingViewController: FiltersViewControllerDelegate {
    func didSelectFilter(_ filter: Filter) {
        guard let imageAdjustableView = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        imageAdjustableView.currentFilter = filter
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

extension ProjectCreatingViewController: ShadowViewControllerDelegate {
    
    func didReportNewShadowModel(_ model: ShadowModel) {
        currentlySelectedAdjustableView.layer.shadowRadius = model.blur
        currentlySelectedAdjustableView.layer.shadowOffset = model.angle
        currentlySelectedAdjustableView.layer.shadowOpacity = model.alpha
        currentlySelectedAdjustableView.layer.shadowColor = model.color
    }
    
    func showShadowViewController() {
        guard let adjustable = currentlySelectedAdjustableView else { return }
        adjustable.layer.shadowOpacity = 1
        adjustable.layer.shadowColor = UIColor.clear.cgColor
        prepareForOnThird(title: LocalizationManager.shared.localizedString(for: .shadowTitle))
        let vc = ShadowViewController()
        vc.originalShadowModel = ShadowModel(layer: adjustable.layer)
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        present(vc, animated: true, completion: nil)
    }
    
    func didDismissShadowController() {
        prepareForFullFromOneThird()
    }
}

extension ProjectCreatingViewController: OpacityViewControllerDelegate {
    
    func showOpacityViewController() {
        guard let selectedAdjustable = currentlySelectedAdjustableView else { return }
        prepareForOnThird(title: LocalizationManager.shared.localizedString(for: .shadowOpacity))
        let opacityController = OpacityViewController()
        opacityController.originalOpacity = Float(selectedAdjustable.alpha)
        opacityController.delegate = self
        opacityController.modalPresentationStyle = .custom
        opacityController.transitioningDelegate = opacityController
        present(opacityController, animated: true, completion: nil)
    }
    
    func didSetOpacity(_ opacity: Float) {
        currentlySelectedAdjustableView?.alpha = CGFloat(opacity)
    }
    
    func didDismissOpacityController() {
        prepareForFullFromOneThird()
    }
}

extension ProjectCreatingViewController: LayersViewControllerDelegate {
    func showLayersController() {
        prepareForOnThird(title: "Layers")
        let layersController = LayersViewController()
        layersController.delegate = self
        layersController.modalPresentationStyle = .custom
        layersController.transitioningDelegate = layersController
        present(layersController, animated: true)
    }
    func didDismissLayers() {
        prepareForFullFromOneThird()
    }
}
