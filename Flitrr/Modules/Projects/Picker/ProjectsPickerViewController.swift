//
//  ProjectsPickerViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 16.05.2022.
//

import UIKit

protocol ProjectsPickerViewControllerDelegate: AnyObject {
    func willMoveProjects(_ projects: [Project])
}

final class ProjectsPickerViewController: UIViewController {
    
    var photosContentMode: UIView.ContentMode = .scaleAspectFill
    
    var closeButton: UIButton!
    private var addButton: UIButton!
    private var gradientLayer: CAGradientLayer!

    weak var delegate: ProjectsPickerViewControllerDelegate!
    var collectionView: UICollectionView!
    
    var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appDark
        setupMainCollectionView()
        
        // setupGradient()
        setupButtons()
        loadAssets()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // gradientLayer.frame = .init(x: 0, y: 0, width: view.bounds.width, height: view.safeAreaInsets.top + 90)
        collectionView.contentInset = .init(top: 30, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    }
    
    func loadAssets() {
        projects = Project.getProjectsNilFolder()
        collectionView.reloadData()
    }
    
    func setupGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 0, alpha: 0.8).cgColor,
            UIColor(white: 0, alpha: 0.4).cgColor,
            UIColor(white: 0, alpha: 0).cgColor
        ]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.shouldRasterize = true
        gradientLayer.rasterizationScale = UIScreen.main.scale
        gradientLayer.startPoint = .init(x: 0.5, y: 0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1)
    }
    
    func setupMainCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: createLayout(cellsPerRow: 2, heightRatio: 1.5, inset: 1, usesHorizontalScroll: false)
        )
        
        collectionView.backgroundColor = .appDark
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: "id")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
    }

    func setupButtons() {
        closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .appAccent
        config.cornerStyle = .large
        addButton = UIButton(configuration: config)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.isEnabled = false
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc func handleAdd() {
        delegate?.willMoveProjects(projects.filter { $0.isSelected })
        dismiss(animated: true)
    }
    
    static func createInstance() -> ProjectsPickerViewController {
        let controller = ProjectsPickerViewController()
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
}

extension ProjectsPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        projects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ProjectCell
        let project = projects[indexPath.row]
        cell.set(project)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        projects[indexPath.row].isSelected.toggle()
        (collectionView.cellForItem(at: indexPath) as? ProjectCell)?.isChecked = projects[indexPath.row].isSelected
        let selectedCount = projects.filter { $0.isSelected }.count
        addButton.isEnabled = selectedCount != 0
    }
}
