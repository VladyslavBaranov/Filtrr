//
//  ProjectsViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 19.04.2022.
//

import SwiftUI

class ProjectsViewController: UIViewController {
    
    // View state section
    enum Mode {
        case projects
        case folders
    }
    var isSelectionModeEnabled = false
    var currentMode: Mode = .projects
    
    // View data section
    var projectHeights: [CGFloat] = [300, 200, 300, 230, 250, 200]
    var folders: [FolderProtocol] = []
    
    // View section
    private var titleLabel: UILabel!
    
    private var gradientLayer: CAGradientLayer!
    private var navigationView: NavigationView!
    private var optionsContainerView: ProjectsOptionsContainerView!
    private var collectionView: UICollectionView!
    
    private var selectionTab: ProjectsSelectionTab!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupCollectionView()
        setupGradient()
        setupTopViews()
        setupSelectionTab()
        loadFolders()
        navigationView.onSettingsButtonTapped = openSettings
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = .init(x: 0, y: 0, width: view.bounds.width, height: view.safeAreaInsets.top + 80)
    }
}

extension ProjectsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentMode == .projects ? projectHeights.count : folders.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ProjectsFolderCell
        
        if currentMode == .folders {
            let folder = folders[indexPath.row]
            cell.setFolder(folder)
        }
        
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let abs = abs(scrollView.contentOffset.y) - view.safeAreaInsets.top

        if abs >= 160 {
            optionsContainerView?.alpha = 1
        } else {
            optionsContainerView?.alpha = 0
        }

        if scrollView.contentOffset.y > -210 {
           // navBar2.alpha = 0
        } else {
           // navBar2.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "hId", for: indexPath)
        as! FoldersCollectionHeaderView
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentMode == .folders {
            let folder = folders[indexPath.row]
            if folder is CreationFolder {
                showFolderCreationAlert()
            }
        }
        
        if isSelectionModeEnabled {
            let cell = collectionView.cellForItem(at: indexPath) as! ProjectsFolderCell
            cell.isChecked.toggle()
        }
    }
}

extension ProjectsViewController: WaterFallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        projectHeights[indexPath.row]
    }
}

extension ProjectsViewController: ProjectsOptionsContainerViewDelegate {
    func didTapOption(tag: Int) {
        switch tag {
        case 0:
            currentMode = .projects
            let layout = WaterFallLayout()
            layout.delegate = self
            collectionView.collectionViewLayout = layout
            projectHeights = [300, 200, 300, 230, 250, 200]
            collectionView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.selectionTab.alpha = 0
            }
        case 1:
            currentMode = .folders
            collectionView.contentInset = .init(top: 160, left: 0, bottom: 100, right: 0)
            collectionView.setCollectionViewLayout(createLayout(cellsPerRow: 2, heightRatio: 1.2, inset: 9.0), animated: false)
            collectionView.alwaysBounceHorizontal = false
        
            collectionView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.selectionTab.alpha = 0
            }
        case 2:
            isSelectionModeEnabled.toggle()
            UIView.animate(withDuration: 0.3) {
                self.selectionTab.alpha = 1
            }
        default:
            break
        }
    }
}

private extension ProjectsViewController {
    func setupUI() {
        view.backgroundColor = .appDark
        tabBarController?.tabBar.isHidden = true
    }
    func setupCollectionView() {
        let layout = WaterFallLayout()
        layout.delegate = self
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProjectsFolderCell.self, forCellWithReuseIdentifier: "id")
        collectionView.register(FoldersCollectionHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "hId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .init(top: 160, left: 20, bottom: 100, right: 20)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    func setupGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 0, alpha: 0.6).cgColor,
            UIColor(white: 0, alpha: 0.3).cgColor,
            UIColor(white: 0, alpha: 0).cgColor
        ]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.shouldRasterize = true
        gradientLayer.rasterizationScale = UIScreen.main.scale
        gradientLayer.startPoint = .init(x: 0.5, y: 0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1)
    }
    func setupTopViews() {
        navigationView = NavigationView(frame: .zero)
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.heightAnchor.constraint(equalToConstant: 80),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        optionsContainerView = ProjectsOptionsContainerView()
        optionsContainerView.delegate = self
        optionsContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(optionsContainerView)
        NSLayoutConstraint.activate([
            optionsContainerView.heightAnchor.constraint(equalToConstant: 80),
            optionsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            optionsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            optionsContainerView.topAnchor.constraint(equalTo: navigationView.bottomAnchor)
        ])
    }
    func setupSelectionTab() {
        selectionTab = ProjectsSelectionTab(frame: .init(
            x: 0,
            y: view.bounds.height - 100,
            width: view.bounds.width,
            height: 100))
        tabBarController?.view.addSubview(selectionTab)
        selectionTab.alpha = 0
    }
    func openSettings() {
        
        let nav = SettingsViewController.createSettingsNavigationController()
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    func loadFolders() {
        folders = Folder.getAvailableFolders()
        folders.append(FavoritesFolder())
        folders.append(CreationFolder())
    }
}

extension ProjectsViewController {
    func showFolderCreationAlert() {
        let alertVC = UIAlertController(
            title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
        alertVC.addTextField()
        alertVC.textFields?.first?.placeholder = "Name"
        alertVC.addAction(.init(title: "Cancel", style: .cancel))
        alertVC.addAction(.init(title: "Create", style: .default, handler: { [weak self] _ in
            if let text = alertVC.textFields?.first?.text {
                let folder = Folder.createFolderAndSave(name: text)
                self?.folders.insert(folder, at: 0)
                self?.collectionView.reloadSections(.init(integer: 0))
            }
        }))
        present(alertVC, animated: true)
    }
}
