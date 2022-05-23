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
    
    var targetImageSize: CGSize = .zero
    weak var delegate: ProjectCreatingViewControllerDelegate!
    private var currentlySelectedAdjustableView: AdjustableView!
    
    private var toolBarView: ToolBarView!
    private var scrollableTabBar: ScrollableRoundedBar!
    private var canvas: Canvas!
	
	private var addedCount = 0
    
    private var initialBackgroundItem = ColorPaletteItem.transparent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        undoManager?.levelsOfUndo = 10
        
        view.backgroundColor = .appDark
        
        if targetImageSize == .zero {
            targetImageSize = .init(width: 1080, height: 1080)
        }
        
        setupToolBar()
        canvas = Canvas()
        canvas.canvas.gridIsActive = false
        canvas.canvas.isTransformingEnabled = false
		canvas.clipsToBounds = true
        //transparentGridView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvas)
        
        if targetImageSize.width < targetImageSize.height {
            let factor = targetImageSize.width / targetImageSize.height
            canvas.frame.size.height = view.bounds.height - UIApplication.shared.getStatusBarHeight() - 190
            canvas.frame.size.width = canvas.frame.size.height * factor
            canvas.frame.origin.y = UIApplication.shared.getStatusBarHeight() + 80
        } else {
            let factor = targetImageSize.width / targetImageSize.height
            canvas.frame.size.width = view.bounds.width
            canvas.frame.size.height = view.bounds.width * factor
            canvas.center.y = view.center.y
        }
        //transparentGridView.frame.origin.y = UIApplication.shared.getStatusBarHeight() + 80
        canvas.center.x = view.center.x
        
        scrollableTabBar = ScrollableRoundedBar(frame: .init(
            x: 0,
            y: view.bounds.height - 80,
            width: view.bounds.width,
            height: 80)
        )
		scrollableTabBar.delegate = self
        scrollableTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollableTabBar)
        
        let tabBarInset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 120 : 0
        NSLayoutConstraint.activate([
            scrollableTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tabBarInset),
            scrollableTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tabBarInset),
            scrollableTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollableTabBar.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        handleUndoRedoUI()
    }

    
    func setupToolBar() {
        toolBarView = ToolBarView(frame: .zero, centerItem: .editSet)
        toolBarView.delegate = self
        toolBarView.trailingItem = .none
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
        canvas.canvas.gridIsActive = true
        toolBarView.centerItem = .title
        toolBarView.leadingItem = .none
        toolBarView.trailingItem = .none
        toolBarView.title = title
        
        let baseHeight = canvas.bounds.height
        let topHeight = view.safeAreaInsets.top + 80
        let vcHeight = view.bounds.height * 0.3
        let destinationHeight = view.bounds.height - vcHeight - topHeight
        let factor = destinationHeight / baseHeight
        
        UIView.animate(withDuration: 0.3) {
            self.canvas.transform = .init(scaleX: factor, y: factor)
                .concatenating(.init(translationX: 0, y: -(baseHeight - baseHeight * factor) / 2))
        }
    }
    func prepareForFullFromOneThird() {
        canvas.canvas.gridIsActive = false
        toolBarView.centerItem = .editSet
        toolBarView.leadingItem = .back
        toolBarView.trailingItem = .none
        UIView.animate(withDuration: 0.3) {
            self.canvas.transform = .identity
        }
    }
    
    private func handleUndoRedoUI() {
        guard let undoManager = undoManager else { return }
        toolBarView.setUndoRedoState(undoManager)
    }
}

extension ProjectCreatingViewController: LayersViewControllerDelegate {
    func didDeleteLayer(_ adjustable: AdjustableView) {
        adjustable.removeFromSuperview()
    }
    
    func showLayersController() {
        let undeletedLayers = canvas.canvas.adjustables.filter { !$0.isDeleted }
        guard !undeletedLayers.isEmpty else { return }
        prepareForOnThird(title: "Layers")
        let layersController = LayersViewController()
        layersController.layers = canvas.canvas.adjustables.filter { !$0.isDeleted }
        layersController.delegate = self
        layersController.modalPresentationStyle = .custom
        layersController.transitioningDelegate = layersController
        present(layersController, animated: true)
    }
    func didDismissLayers() {
        prepareForFullFromOneThird()
    }
}

extension ProjectCreatingViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {}
    
    func didTapLeadingItem() {
        canvas.canvas.prepareForRendering()
        
        let alert = UIAlertController(
            title: LocalizationManager.shared.localizedString(for: .alertTitle),
            message: LocalizationManager.shared.localizedString(for: .alertDesc),
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(
            title: LocalizationManager.shared.localizedString(for: .alertA3), style: .cancel) { [unowned self] _ in
            if StoreObserver.shared.isSubscribed() {
                guard let png = canvas.renderPNG() else { return }
                Project.createProjectAndSave(
                    pngData: png)
                NotificationCenter.default.post(
                    name: Notification.Name("shouldReloadProjectNotificationDidReceive"),
                    object: nil
                )
                dismiss(animated: true)
            } else {
                let controller = PaywallHostingController(rootView: PaywallView())
                if UIDevice.current.userInterfaceIdiom == .phone {
                    controller.modalPresentationStyle = .fullScreen
                }
                present(controller, animated: true)
            }
        }
        
        alert.addAction(saveAction)
        
        
        let discardAction = UIAlertAction(
            title: LocalizationManager.shared.localizedString(for: .alertA1), style: .destructive) { [unowned self] _ in
            dismiss(animated: true)
        }
        
        alert.addAction(discardAction)
        let cancelAction = UIAlertAction(title: LocalizationManager.shared.localizedString(for: .alertA2), style: .default)
        
        alert.addAction(cancelAction)
        
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
            showGraphicsController()
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
        case .adjust:
            showAdjustController()
		}
	}
}

extension ProjectCreatingViewController: AdjustableViewDelegate {
    
    func didToggle(_ view: AdjustableView) {
        currentlySelectedAdjustableView = view
    }
    
    func frameDidChange(_ view: AdjustableView) {}
}

extension ProjectCreatingViewController: ImageLibraryPickerViewControllerDelegate {
    
    func showImagePicker() {
        let controller = ImageLibraryPickerViewController.createInstance()
        controller.delegate = self
        if UIDevice.current.userInterfaceIdiom == .phone {
            controller.modalPresentationStyle = .fullScreen
        }
        present(controller, animated: true)
    }
    
    func didSelectImage(uiImage: UIImage) {
        addedCount += 1
        
        guard addedCount == 2 else { return }
        let adjustable = AdjustableImageView(frame:
                .init(x: 0, y: 0, width: canvas.bounds.midX, height: canvas.bounds.midY))
        adjustable.originalImage = uiImage
        adjustable.imageDelegate = self
        adjustable.delegate = self
        didAddImage(adjustable)
        addedCount = 0
    }
    
    private func didAddImage(_ adjustable: AdjustableView) {
        canvas.add(adjustable)
        undoManager?.registerUndo(withTarget: self, handler: { target in
            target.canvas.remove(adjustable)
            target.handleUndoRedoUI()
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
        toolBarView.trailingItem = .none
        // toolBarView.
        UIView.animate(withDuration: 0.3) {
            self.canvas.transform = .identity
        }
    }
    
}

extension ProjectCreatingViewController: TextEditingViewControllerDelegate {
    
    func showTextEditing() {
        let controller = TextEditingViewController()
        controller.delegate = self
        if UIDevice.current.userInterfaceIdiom == .phone {
            controller.modalPresentationStyle = .fullScreen
        }
        present(controller, animated: true, completion: nil)
    }
    
    func didConfirmText(_ attributedString: NSAttributedString) {
        let label = AdjustableLabel.createLabel(for: attributedString)
        label.delegate = self
        didAddLabel(label)
    }
    
    private func didAddLabel(_ adjustable: AdjustableLabel) {
        canvas.add(adjustable)
        undoManager?.registerUndo(withTarget: self, handler: { target in
            target.canvas.remove(adjustable)
        })
    }
}

extension ProjectCreatingViewController: GraphicViewControllerDelegate {
    func didSelectGraphic(_ uiImage: UIImage) {
        let graphic = AdjustableImageView(frame:
                .init(x: 0, y: 0, width: canvas.bounds.midX, height: canvas.bounds.midY))
        graphic.originalImage = uiImage
        graphic.imageDelegate = self
        graphic.delegate = self
        canvas.add(graphic)
        
        undoManager?.registerUndo(withTarget: self, handler: { [unowned self] h in
            canvas.remove(graphic)
        })
    }
    
    func showGraphicsController() {
        let vc = GraphicViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension ProjectCreatingViewController: ShapesViewControllerDelegate {
    func showShapesController() {
        let controller = ShapesViewController()
        controller.delegate = self
        if UIDevice.current.userInterfaceIdiom == .phone {
            controller.modalPresentationStyle = .fullScreen
        }
        present(controller, animated: true, completion: nil)
    }
    func didSelectBasicShape(_ name: String, size: CGSize) {
        let shape = AdjustableImageView(frame:
                .init(x: 0, y: 0, width: size.width, height: size.height))
        shape.imageDelegate = self
        shape.delegate = self
        shape.originalImage = UIImage(named: name)
        shape.imageView.image = UIImage(named: name)
        canvas.add(shape)
        
        undoManager?.registerUndo(withTarget: self, handler: { [unowned self] _ in
            canvas.remove(shape)
        })
    }
}

extension ProjectCreatingViewController: BackgroundSelectionViewControllerDelegate {
    func showBackgroundController() {
        prepareForOnThird(title: LocalizationManager.shared.localizedString(for: .backgroundTitle))
        let vc = BackgroundSelectionViewController()
        vc.initialBackgroundMode = canvas.canvas.bakgroundMode
        vc.initialPaletteItem = initialBackgroundItem
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        present(vc, animated: true, completion: nil)
    }
    
    func shouldFillWithGradient(_ paletteItem: ColorPaletteItem, _ colors: [UIColor]) {
        initialBackgroundItem = paletteItem
        canvas.canvas.bakgroundMode = .gradient(colors)
    }
    
    func shouldFillWithImage(_ paletteItem: ColorPaletteItem, _ uiImage: UIImage) {
        initialBackgroundItem = paletteItem
        canvas.canvas.bakgroundMode = .image(uiImage)
    }
    
    func shouldFillBackgroundWithPlain(_ paletteItem: ColorPaletteItem, _ color: UIColor) {
        initialBackgroundItem = paletteItem
        canvas.canvas.bakgroundMode = .plainColor(color)
    }
    
    func didDismissBackgroundSelection(didSelectNew: Bool, initialMode: CanvasCoreView.BackgroundMode) {
        prepareForFullFromOneThird()
        if didSelectNew {
            didChangeBackground(
                newItem: canvas.canvas.bakgroundMode,
                oldItem: initialMode
            )
        }
    }
    
    private func didChangeBackground(
        newItem: CanvasCoreView.BackgroundMode,
        oldItem: CanvasCoreView.BackgroundMode) {
            canvas.canvas.bakgroundMode = newItem
        undoManager?.registerUndo(withTarget: self, handler: { target in
            target.canvas.canvas.bakgroundMode = oldItem
            target.didChangeBackground(newItem: oldItem, oldItem: newItem)
        })
    }
}

extension ProjectCreatingViewController: AdjustableImageViewDelegate {
    
    func didUpdateImage(_ view: AdjustableImageView, _ newImage: UIImage) {
        guard let old = view.imageView.image else { return }
        didUpdateImageAdj(view, newImage, oldImage: old)
    }
    
    func didToggleFilterMode(_ view: AdjustableImageView) {}
    
    private func didUpdateImageAdj(_ view: AdjustableImageView, _ newImage: UIImage, oldImage: UIImage) {
        view.imageView.image = newImage
        undoManager?.registerUndo(withTarget: self, handler: { target in
            target.didUpdateImageAdj(view, oldImage, oldImage: newImage)
        })
    }
}

extension ProjectCreatingViewController: FiltersViewControllerDelegate {
    
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
    
    func didSelectFilter(_ filter: Filter) {
        guard let imageAdjustableView = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        if filter.filterName.isEmpty {
            imageAdjustableView.removeAllFilters()
        } else {
            imageAdjustableView.add(filter)
        }
        
        // imageAdjustableView.currentFilter = filter
    }
    
    func didSelectBlendMode(_ filterName: String) {
        currentlySelectedAdjustableView.layer.compositingFilter = filterName
    }
    
    func didDismissFilters() {
        toolBarView.leadingItem = .back
        toolBarView.trailingItem = .none
        toolBarView.centerItem = .editSet
        canvas.canvas.gridIsActive = false
        toolBarView.centerItem = .editSet
        toolBarView.leadingItem = .back
        toolBarView.trailingItem = .none
        UIView.animate(withDuration: 0.3) {
            self.canvas.transform = .identity
        }
    }
}

extension ProjectCreatingViewController: AdjustViewControllerDelegate {
    func didReportValue(_ value: Float, option: AdjustViewController.Option) {
        guard let adjustable = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        var filterName = ""
        var parameters: [String: Any] = [:]
        switch option {
        case .none:
            break
        case .contrast:
            filterName = "CIColorControls"
            parameters["inputContrast"] = value * 5
        case .saturation:
            filterName = "CIColorControls"
            parameters["inputSaturation"] = value * 5
        case .brightness:
            filterName = "CIColorControls"
            parameters["inputBrightness"] = value
        }
        adjustable.applyToCI(name: filterName, paramaters: parameters)
    }
    
    func didDismissAdjustController() {
        
    }
    func shouldRemoveBackground() {
        guard let adjustable = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        adjustable.imageView.image = adjustable.originalImage.rmBG()
    }
    func showAdjustController() {
        let controller = AdjustViewController()
        controller.modalPresentationStyle = .custom
        controller.delegate = self
        controller.transitioningDelegate = controller
        present(controller, animated: true)
    }
}

extension ProjectCreatingViewController: CropViewControllerDelegate {
    func showCropViewController() {
        guard let adjustable = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        guard let image = adjustable.imageView.image else { return }
        let controller = CropViewController()
        controller.delegate = self
        controller.originalImage = image
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true)
    }
    func didCut(_ image: UIImage) {
        guard let imageAdjustableView = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        guard let currentImg = imageAdjustableView.imageView.image else { return }
        didCutImage(image, oldImage: currentImg)
    }
    private func didCutImage(_ newImage: UIImage, oldImage: UIImage) {
        guard let imageAdjustableView = currentlySelectedAdjustableView as? AdjustableImageView else { return }
        imageAdjustableView.imageView.image = newImage
        undoManager?.registerUndo(withTarget: self, handler: { target in
            target.didCutImage(oldImage, oldImage: newImage)
        })
    }
}

extension ProjectCreatingViewController: ShadowViewControllerDelegate {
    
    func didReportNewShadowModel(_ model: ShadowModel, orignaModel: ShadowModel, isFinal: Bool) {
        if isFinal {
            setShadowModel(
                model,
                originalModel: orignaModel,
                adjustable: currentlySelectedAdjustableView
            )
        }
        currentlySelectedAdjustableView.shadowModel = model
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
    
    private func setShadowModel(
        _ model: ShadowModel, originalModel: ShadowModel, adjustable: AdjustableView
    ) {
        adjustable.shadowModel = model
        undoManager?.registerUndo(withTarget: self, handler: { target in
            target.setShadowModel(originalModel, originalModel: model, adjustable: adjustable)
        })
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
    
    func didSetOpacity(_ opacity: Float, originalOpacity: Float, isFinal: Bool) {
        if isFinal {
            setOpacity(CGFloat(opacity), originalOpacity: CGFloat(originalOpacity), adjustable: currentlySelectedAdjustableView)
        }
        currentlySelectedAdjustableView?.alpha = CGFloat(opacity)
    }
    
    func didDismissOpacityController() {
        prepareForFullFromOneThird()
    }
    
    private func setOpacity(
        _ opacity: CGFloat, originalOpacity: CGFloat, adjustable: AdjustableView?) {
        adjustable?.alpha = opacity
        undoManager?.registerUndo(withTarget: self, handler: { target in
            target.setOpacity(originalOpacity, originalOpacity: opacity, adjustable: adjustable)
        })
    }
    
}
