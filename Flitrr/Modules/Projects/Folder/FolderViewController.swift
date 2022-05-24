//
//  FolderViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 15.05.2022.
//

import UIKit

final class FolderViewController: UIViewController {
    
    var isFavoritesMode = false
    var projects: [Project] = []
    
    var folder: Folder!
    private var closeButton: UIButton!
    private var navigationView: NavigationView!
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupTopUI()
        if !isFavoritesMode {
            loadFolderProjects()
        }
    }
    
    func setupTopUI() {
        
        view.backgroundColor = .appDark
        
        closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        navigationView = NavigationView(frame: .zero)
        if isFavoritesMode {
            navigationView.title = LocalizationManager.shared.localizedString(for: .projectsFolders)
        } else {
            navigationView.trailingButtonMode = .folderEdit
            navigationView.setMenuForTrailingButton(createMenu())
            navigationView.title = folder.name ?? ""
        }
        
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.heightAnchor.constraint(equalToConstant: 80),
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: closeButton.bottomAnchor)
        ])
    }
    
    private func setupCollection() {
        let rowsCount = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 3
        let layout = createLayout(cellsPerRow: rowsCount, heightRatio: 1.5, inset: 9.0, usesHorizontalScroll: false, usesHeader: false)
        // layout.delegate = self
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .appDark
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: "projectsId")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .init(top: 110, left: 0, bottom: 0, right: 0)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    func createMenu() -> UIMenu {
        
        let action1 = UIAction(
            title: LocalizationManager.shared.localizedString(for: .folderViewAddProj),
            image: .init(systemName: "plus")
        ) { [unowned self] _ in
            showProjectsPicker()
        }
        
        let action2 = UIAction(
            title: LocalizationManager.shared.localizedString(for: .folderViewRename),
            image: .init(systemName: "pencil")
        ) { [unowned self] _ in
            showRanamingUI()
        }
        
        let addNewMenu = UIMenu(
            title: "",
            children: [action1, action2])
        
        return addNewMenu
    }
    
    func showProjectsPicker() {
        let controller = ProjectsPickerViewController.createInstance()
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func showRanamingUI() {
        let alertController = UIAlertController(
            title: LocalizationManager.shared.localizedString(for: .folderViewRename), message: nil, preferredStyle: .alert)
        alertController.addTextField { [unowned self] textField in
            textField.text = folder.name
            textField.clearButtonMode = .always
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        let cancelAction = UIAlertAction(
            title: LocalizationManager.shared.localizedString(for: .alertA2), style: .cancel)
        alertController.addAction(cancelAction)
        let saveAction = UIAlertAction(
            title: LocalizationManager.shared.localizedString(for: .alertA3), style: .default) { [unowned self] _ in
            if let text = alertController.textFields?.first?.text {
                if folder.rename(text) {
                    navigationView.title = text
                }
            }
        }
        alertController.addAction(saveAction)
        present(alertController, animated: true)
    }
    
    func loadFolderProjects() {
        guard let uuid = folder.id else { return }
        let projects = Project.getProjects(folder_id: uuid)
        if !projects.isEmpty {
            self.projects = projects
            collectionView.reloadData()
        }
    }
}

extension FolderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        projects.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectsId", for: indexPath) as! ProjectCell
        cell.set(projects[indexPath.row])
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + view.safeAreaInsets.top + 80 + closeButton.bounds.height
        if offset > 0 {
            let fraction = 1 - offset / 160
            navigationView.alpha = fraction
        } else {
            navigationView.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        let vc = ProjectLookViewController()
        vc.project = project
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension FolderViewController: ProjectsPickerViewControllerDelegate {
    func willMoveProjects(_ projects: [Project]) {
        _ = folder.insert(projects: projects)
        loadFolderProjects()
    }
}
