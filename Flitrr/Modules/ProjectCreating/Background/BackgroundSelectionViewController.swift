//
//  BackgroundSelectionViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 08.05.2022.
//

import UIKit

protocol BackgroundSelectionViewControllerDelegate: AnyObject {
    func didDismissBackgroundSelection()
    func shouldFillBackgroundWithPlain(_ color: UIColor)
    func shouldFillWithImage(_ uiImage: UIImage)
}

final class BackgroundSelectionViewController: UIViewController {
    
    var addedCount = 0
    private let titles = ["Image", "Transparent", "Color", "Gradient", "Pastel"]
    
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
        toolBarView.title = "Color"
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
        delegate?.didDismissBackgroundSelection()
        dismiss(animated: true)
    }
    func didTapLeadingItem() {
        delegate?.didDismissBackgroundSelection()
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
            delegate?.shouldFillBackgroundWithPlain(.clear)
            delegate?.didDismissBackgroundSelection()
            dismiss(animated: true)
        case 2:
            break
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
        case .gradient:
            break
        case .color(let uIColor):
            delegate?.shouldFillBackgroundWithPlain(uIColor)
        }
    }
}

extension BackgroundSelectionViewController: ImageLibraryPickerViewControllerDelegate {
    func didSelectImage(uiImage: UIImage) {
        addedCount += 1
        if addedCount == 2 {
            delegate?.shouldFillWithImage(uiImage)
            delegate?.didDismissBackgroundSelection()
            dismiss(animated: true)
        }
    }
}
