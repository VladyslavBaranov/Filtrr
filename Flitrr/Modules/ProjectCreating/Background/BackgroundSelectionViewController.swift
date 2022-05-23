//
//  BackgroundSelectionViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 08.05.2022.
//

import UIKit

protocol BackgroundSelectionViewControllerDelegate: AnyObject {
    func didDismissBackgroundSelection(didSelectNew: Bool, initialMode: CanvasCoreView.BackgroundMode)
    func shouldFillBackgroundWithPlain(_ paletteItem: ColorPaletteItem, _ color: UIColor)
    func shouldFillWithImage(_ paletteItem: ColorPaletteItem, _ uiImage: UIImage)
    func shouldFillWithGradient(_ paletteItem: ColorPaletteItem, _ colors: [UIColor])
}

final class BackgroundSelectionViewController: UIViewController {
    
    var initialBackgroundMode: CanvasCoreView.BackgroundMode!
    var initialPaletteItem: ColorPaletteItem!
    
    var addedCount = 0
    private let titles = [
        LocalizationManager.shared.localizedString(for: .backgroundImage),
        LocalizationManager.shared.localizedString(for: .backgroundTrans),
        LocalizationManager.shared.localizedString(for: .textColor),
        LocalizationManager.shared.localizedString(for: .backgroundGradient),
        LocalizationManager.shared.localizedString(for: .backgroundPastel)
    ]
    
    weak var delegate: BackgroundSelectionViewControllerDelegate!
    private var toolBarView: ToolBarView!
    private var palette: ColorPaletteCollectionView!
    private var backgroundPickerView: ValuePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appGray
        setupToolBar()
        setupOptionsPicker()
        backgroundPickerView.titles = titles
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        palette = ColorPaletteCollectionView(
            frame: .init(x: 0, y: 80, width: view.bounds.width, height: 90), collectionViewLayout: layout
        )
        palette.paletteDelegate = self
        palette.backgroundSetColors()
        view.addSubview(palette)
        backgroundPickerView.selectedIndex = 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundPickerView.frame = .init(
            x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80)
        palette.frame = .init(x: 0, y: view.bounds.midY - 45, width: view.bounds.width, height: 90)
    }
    
    func setupToolBar() {
        toolBarView = ToolBarView(frame: .zero, centerItem: .title)
        toolBarView.leadingItem = .cancel
        toolBarView.trailingItem = .confirm
        toolBarView.title = LocalizationManager.shared.localizedString(for: .textColor)
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
        backgroundPickerView = ValuePickerView(
            frame: .init(x: 0, y: view.bounds.height - 80, width: view.bounds.width, height: 80))
        backgroundPickerView.delegate = self
        view.addSubview(backgroundPickerView)
    }
}

extension BackgroundSelectionViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        delegate?.didDismissBackgroundSelection(didSelectNew: true, initialMode: initialBackgroundMode)
        dismiss(animated: true)
    }
    func didTapLeadingItem() {
        didSelectItem(initialPaletteItem)
        delegate?.didDismissBackgroundSelection(didSelectNew: false, initialMode: initialBackgroundMode)
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}

extension BackgroundSelectionViewController: ValuePickerViewDelegate {
    func didSelectValue(at index: Int) {
        switch index {
        case 0:
            let controller = ImageLibraryPickerViewController.createInstance()
            controller.delegate = self
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        case 1:
            delegate?.shouldFillBackgroundWithPlain(.transparent, .clear)
            delegate?.didDismissBackgroundSelection(didSelectNew: false, initialMode: initialBackgroundMode)
            dismiss(animated: true)
        case 2:
            palette.backgroundSetColors()
        case 3:
            palette.backgroundSetGradients()
        case 4:
            palette.backgroundSetPastel()
        default:
            break
        }
        toolBarView.title = titles[index]
    }
}

extension BackgroundSelectionViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FractionPresentationController(presentedViewController: presented, presenting: presenting, heightFactor: 0.3)
    }
}

extension BackgroundSelectionViewController: ColorPaletteCollectionViewDelegate {
    func didSelectItem(_ item: ColorPaletteItem) {
        switch item {
        case .fill:
            break
        case .textColor:
            break
        case .gradient(let colors, _, _):
            delegate?.shouldFillWithGradient(item, colors)
        case .color(let uIColor):
            delegate?.shouldFillBackgroundWithPlain(item, uIColor)
        case .picker:
            break
        case .transparent:
            break
        default:
            break
        }
    }
}

extension BackgroundSelectionViewController: ImageLibraryPickerViewControllerDelegate {
    func didSelectImage(uiImage: UIImage) {
        addedCount += 1
        if addedCount == 2 {
            delegate?.shouldFillWithImage(initialPaletteItem, uiImage)
            delegate?.didDismissBackgroundSelection(didSelectNew: false, initialMode: initialBackgroundMode)
            dismiss(animated: true)
        }
    }
}
