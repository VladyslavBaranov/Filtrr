//
//  ProjectLookViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 21.05.2022.
//

import UIKit

final class ProjectLookViewController: UIViewController {
    
    var project: Project!
    
    var closeButton: UIButton!
    
    var shareButton: UIButton!
    var infoButton: UIButton!
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        
        view.backgroundColor = .appDark
        
        imageView = UIImageView()
        if let data = project.getPNGData() {
            imageView.image = UIImage(data: data)
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        
        shareButton = UIButton()
        shareButton.setPreferredSymbolConfiguration(.init(pointSize: 28), forImageIn: .normal)
        shareButton.setImage(.init(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        shareButton.tintColor = .appAccent
        
        infoButton = UIButton()
        infoButton.setPreferredSymbolConfiguration(.init(pointSize: 28), forImageIn: .normal)
        infoButton.setImage(.init(systemName: "info.circle"), for: .normal)
        infoButton.tintColor = .appAccent
        infoButton.addTarget(self, action: #selector(presentProjectInfo), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [shareButton, infoButton])
        stack.spacing = 15
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

    }
    
    @objc func shareAction() {
        guard let img = imageView.image else { return }
        let controller = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        present(controller, animated: true)
    }
    
    @objc func presentProjectInfo() {
        let vc = ProjectFileInfoViewController(style: .insetGrouped)
        vc.imageSize = imageView.image?.size ?? .zero
        vc.project = project
        if let pController = vc.presentationController as? UISheetPresentationController {
            pController.prefersGrabberVisible = true
            pController.detents = [.medium()]
        }
        present(vc, animated: true)
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
}
