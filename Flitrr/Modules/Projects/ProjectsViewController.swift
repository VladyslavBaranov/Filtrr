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
    
    private var numberOfFavorites: Int = 0
    var projects: [Project] = Project.getAllAvailableProjects()
    
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadProjects),
            name: Notification.Name("shouldReloadProjectNotificationDidReceive"),
            object: nil
        )
    }
    
    private func reevaluateFavorites() {
        numberOfFavorites = projects.filter { $0.isFavorite }.count
    }
    @objc func reloadProjects() {
        projects = Project.getAllAvailableProjects()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadProjects()
        localize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = .init(x: 0, y: 0, width: view.bounds.width, height: view.safeAreaInsets.top + 80)
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let whiteComponent: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0 : 1
        gradientLayer.colors = [
            UIColor(white: whiteComponent, alpha: 0.6).cgColor,
            UIColor(white: whiteComponent, alpha: 0.3).cgColor,
            UIColor(white: whiteComponent, alpha: 0).cgColor
        ]
    }
}

extension ProjectsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentMode == .projects ? projects.count : folders.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        switch currentMode {
        case .folders:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ProjectsFolderCell
            let folder = folders[indexPath.row]
            if folder.isForFavorites {
                cell.folderCountLabel.text = "\(numberOfFavorites)"
            }
            cell.setFolder(folder)
            return cell
        case .projects:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectsId", for: indexPath) as! ProjectCell
            let project = projects[indexPath.row]
            cell.set(project)
            return cell
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + view.safeAreaInsets.top + 160
        if offset > 0 {
            let fraction = 1 - offset / 160
            navigationView.alpha = fraction
            optionsContainerView?.alpha = fraction
        } else {
            navigationView.alpha = 1
            optionsContainerView?.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "hId", for: indexPath)
        as! FoldersCollectionHeaderView
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch currentMode {
        case .projects:
            if isSelectionModeEnabled {
                projects[indexPath.row].isSelected.toggle()
                (collectionView.cellForItem(at: indexPath) as? ProjectCell)?.isChecked = projects[indexPath.row].isSelected
                let selectedObjectsCount = projects.filter { $0.isSelected }.count
                selectionTab.title = "\(selectedObjectsCount) Projects Selected"
            } else {
                let vc = ProjectLookViewController()
                vc.project = projects[indexPath.row]
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        case .folders:
            let folder = folders[indexPath.row]
            if folder is CreationFolder {
                showFolderCreationAlert()
                return
            }
            if folder.isForFavorites {
                showContentsOfFavorites()
                return
            }
            showContentsOfFolder(folder as! Folder)
        }
    }
}

/*
extension ProjectsViewController: WaterFallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        projectHeights[indexPath.row]
    }
}
*/

extension ProjectsViewController: ProjectsOptionsContainerViewDelegate {
    func didTapOption(tag: Int) {
        switch tag {
        case 0:
            
            currentMode = .projects
            // let layout = WaterFallLayout()
            // layout.delegate = self
            // collectionView.collectionViewLayout = layout
            // projectHeights = [300, 200, 300, 230, 250, 200]
            let rowsCount = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 4
            let layout = createLayout(cellsPerRow: rowsCount, heightRatio: 1.5, inset: 9.0, usesHorizontalScroll: false, usesHeader: false)
            collectionView.collectionViewLayout = layout
            reloadProjects()
            UIView.animate(withDuration: 0.3) {
                self.selectionTab.alpha = 0
            }
        case 1:
            currentMode = .folders
            reevaluateFavorites()
            let rowsCount = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 4
            let layout = createLayout(cellsPerRow: rowsCount, heightRatio: 1.2, inset: 9.0, usesHorizontalScroll: false)
            collectionView.collectionViewLayout = layout
            collectionView.alwaysBounceHorizontal = false
        
            collectionView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.selectionTab.alpha = 0
            }
        case 2:
            
            isSelectionModeEnabled.toggle()
            
            if isSelectionModeEnabled {
                optionsContainerView.set(state: false, for: 0)
                optionsContainerView.set(state: false, for: 1)
                optionsContainerView.set(title: "Cancel", index: 2)
                
                UIView.animate(withDuration: 0.3) {
                    self.selectionTab.alpha = 1
                }

            } else {
                optionsContainerView.set(state: true, for: 0)
                optionsContainerView.set(state: true, for: 1)
                optionsContainerView.set(title: "Select", index: 2)
                
                for project in projects {
                    project.isSelected = false
                    collectionView.visibleCells.forEach { cell in
                        (cell as? ProjectCell)?.isChecked = false
                    }
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.selectionTab.alpha = 0
                }
            }
            
            
        default:
            break
        }
    }
    
    func localize() {
        navigationView.title = LocalizationManager.shared.localizedString(for: .projectsTitle)
        optionsContainerView.setTitles([
            LocalizationManager.shared.localizedString(for: .projectsTitle),
            LocalizationManager.shared.localizedString(for: .projectsFolders),
            LocalizationManager.shared.localizedString(for: .projectsSelect)
        ])
    }
}

private extension ProjectsViewController {
    func setupUI() {
        view.backgroundColor = .appDark
        tabBarController?.tabBar.isHidden = true
    }
    func setupCollectionView() {
        
        
        let rowsCount = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 4
        let layout = createLayout(cellsPerRow: rowsCount, heightRatio: 1.5, inset: 9.0, usesHorizontalScroll: false, usesHeader: false)
        // layout.delegate = self
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .appDark
		collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProjectsFolderCell.self, forCellWithReuseIdentifier: "id")
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: "projectsId")
        collectionView.register(FoldersCollectionHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "hId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .init(top: 160, left: 0, bottom: 100, right: 0)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    func setupGradient() {
        gradientLayer = CAGradientLayer()
        let whiteComponent: CGFloat = traitCollection.userInterfaceStyle == .dark ? 0 : 1
        gradientLayer.colors = [
            UIColor(white: whiteComponent, alpha: 0.6).cgColor,
            UIColor(white: whiteComponent, alpha: 0.3).cgColor,
            UIColor(white: whiteComponent, alpha: 0).cgColor
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
        navigationView.trailingButtonMode = .settings
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
        
        let optionsInset: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 40 : 120
        
        NSLayoutConstraint.activate([
            optionsContainerView.heightAnchor.constraint(equalToConstant: 80),
            optionsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: optionsInset),
            optionsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -optionsInset),
            optionsContainerView.topAnchor.constraint(equalTo: navigationView.bottomAnchor)
        ])
    }
    func setupSelectionTab() {
        selectionTab = ProjectsSelectionTab(frame: .init(
            x: 0,
            y: view.bounds.height - 100,
            width: view.bounds.width,
            height: 100))
        selectionTab.delegate = self
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
    func showContentsOfFavorites() {
        let favorites = projects.filter { $0.isFavorite }
        print(favorites.map { $0.folder_id })
        let controller = FolderViewController()
        controller.isFavoritesMode = true
        controller.projects = favorites
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    func showContentsOfFolder(_ folder: Folder) {
        let controller = FolderViewController()
        controller.folder = folder
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
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
                self?.collectionView.reloadData()
            }
        }))
        present(alertVC, animated: true)
    }
}

extension ProjectsViewController: ProjectsSelectionTabDelegate {
    func didTapShare() {
        print("SHARE")
    }
    
    func didTapTrash() {
        let selectedObjectsCount = projects.filter { $0.isSelected }.count
        let alert = UIAlertController(
            title: "Delete \(selectedObjectsCount) Projects",
            message: "This action is irreversible", preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            let selectedObjects = projects.filter { $0.isSelected }
            for selectedObject in selectedObjects {
                _ = Project.deleteProject(selectedObject)
            }
            projects.removeAll { $0.isSelected }
            collectionView.reloadData()
        }
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
}
