//
//  AppearanceViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 13.05.2022.
//

import UIKit

struct AppearanceItem {
    var isSelected = false
    var imageName: String = ""
    var title: String = ""
}

struct AppearanceSection {
    var title: String
    var items: [AppearanceItem] = []
    
    mutating func toggle(at index: Int) {
        for i in 0..<items.count {
            items[i].isSelected = i == index
        }
    }
}

final class AppearanceViewCell: UICollectionViewCell {
    
    var iconImageView: UIImageView!
    var label: UILabel!
    var checkMarkButton: UIButton!
    
    var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        iconImageView = .init()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 20
        iconImageView.layer.cornerCurve = .continuous
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Montserrat.medium(size: 16)
        
        checkMarkButton = UIButton()
        checkMarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        checkMarkButton.setPreferredSymbolConfiguration(.init(pointSize: 23), forImageIn: .normal)
        checkMarkButton.setTitleColor(.black, for: .normal)
        stackView = UIStackView(arrangedSubviews: [iconImageView, label, checkMarkButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setItem(_ item: AppearanceItem) {
        if !item.imageName.isEmpty {
            label.isHidden = true
            iconImageView.image = UIImage(named: item.imageName)
        } else {
            label.isHidden = false
        }
        
        if !item.title.isEmpty {
            iconImageView.isHidden = true
            label.text = item.title
        } else {
            iconImageView.isHidden = false
        }
        
        if item.isSelected {
            checkMarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkMarkButton.tintColor = .appAccent
        } else {
            checkMarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkMarkButton.tintColor = .lightGray
        }
    }
}

final class AppearanceHeaderView: UICollectionReusableView {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
    var associatedHeaderIndex = 0
    
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
        titleLabel.text = "Latest Collections"
        titleLabel.font = Montserrat.medium(size: 17)
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSeeAllAction() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = .init(x: 10, y: 0, width: titleLabel.frame.width, height: bounds.height)
    }
}

final class AppearanceViewController: UIViewController {
    
    private var sections: [AppearanceSection] = [
        .init(
            title: LocalizationManager.shared.localizedString(for: .settingsIcon),
            items: [
                .init(isSelected: true, imageName: "Icon-1", title: ""),
                .init(isSelected: false, imageName: "Icon-3", title: ""),
                .init(isSelected: false, imageName: "Icon-2", title: "")
            ]
        ),
        .init(
            title: LocalizationManager.shared.localizedString(for: .settingsAppearance),
            items: [
                .init(isSelected: false, imageName: "", title: LocalizationManager.shared.localizedString(for: .settingsLight)),
                .init(isSelected: false, imageName: "", title: LocalizationManager.shared.localizedString(for: .settingsDark)),
                .init(isSelected: true, imageName: "", title: LocalizationManager.shared.localizedString(for: .settingsSystem))
            ]
        )
    ]
    
    private var toolBarView: ToolBarView!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupState()
        setupToolBar()
        setupCollection()
        view.backgroundColor = .appDark
    }
    
    func setupState() {
        let currentIcon = AppState.shared.string(forKey: .appearanceIcon)
        switch currentIcon {
        case "":
            sections[0].toggle(at: 0)
        case "Icon2":
            sections[0].toggle(at: 1)
        case "Icon3":
            sections[0].toggle(at: 2)
        default:
            break
        }
        let currentTheme = AppState.shared.getUserInterfaceStyle()
        switch currentTheme {
        case .unspecified:
            sections[1].toggle(at: 2)
        case .light:
            sections[1].toggle(at: 0)
        case .dark:
            sections[1].toggle(at: 1)
        @unknown default:
            sections[1].toggle(at: 0)
        }
    }
    
    func setupToolBar() {
        toolBarView = ToolBarView(frame: .zero, centerItem: .title)
        toolBarView.backgroundColor = .clear
        toolBarView.leadingItem = .cancel
        toolBarView.trailingItem = .none
        toolBarView.title = LocalizationManager.shared.localizedString(for: .settingsAppearance)
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
    
    func setupCollection() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(cellsPerRow: 3, heightRatio: 1.2, inset: 9, usesHorizontalScroll: true))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AppearanceViewCell.self, forCellWithReuseIdentifier: "id")
        collectionView.register(AppearanceHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "hId")
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: toolBarView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

extension AppearanceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "hId", for: indexPath) as! AppearanceHeaderView
        view.title = sections[indexPath.section].title
        return view
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! AppearanceViewCell
        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = 8
        cell.layer.cornerCurve = .continuous
        cell.setItem(sections[indexPath.section].items[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard UIApplication.shared.supportsAlternateIcons else { return }
            if indexPath.row == 0 {
                UIApplication.shared.setAlternateIconName(nil)
            } else {
                UIApplication.shared.setAlternateIconName("Icon\(indexPath.row + 1)")
                AppState.shared.set("Icon\(indexPath.row + 1)", forKey: .appearanceIcon)
            }
            sections[0].toggle(at: indexPath.row)
            collectionView.reloadData()
        } else {
            guard let window = view.window else { return }
            sections[1].toggle(at: indexPath.row)
            collectionView.reloadData()
            let styles: [UIUserInterfaceStyle] = [.light, .dark, .unspecified]
            AppState.shared.set(styles[indexPath.row])
            UIView.animate(withDuration: 0.3) {
                window.overrideUserInterfaceStyle = styles[indexPath.row]
            }
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print(scrollView.contentOffset.y)
    }
}

extension AppearanceViewController: ToolBarViewDelegate {
    func didTapTrailingItem() {
        dismiss(animated: true)
    }
    func didTapLeadingItem() {
        dismiss(animated: true)
    }
    func didTapUndo() {}
    func didTapLayers() {}
    func didTapRedo() {}
}
