//
//  RoundedTabBarController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 18.04.2022.
//

import UIKit

final class RoundedTabBarController: UITabBarController {
    var roundedTabBar: RoundedTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedTabBar = RoundedTabBar(frame: .init(
            x: 0,
            y: view.bounds.height - 80,
            width: view.bounds.width,
            height: 80)
        )
        roundedTabBar.delegate = self
        roundedTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roundedTabBar)
        
        let tabBarInset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 120 : 0
        NSLayoutConstraint.activate([
            roundedTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tabBarInset),
            roundedTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tabBarInset),
            roundedTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            roundedTabBar.heightAnchor.constraint(equalToConstant: 100)
        ])
        roundedTabBar.delegate = self
        didTapItem(0)
    }
}

extension RoundedTabBarController: RoundedTabBarDelegate {
    func didTapItem(_ tag: Int) {
        guard let controllers = viewControllers else { return }
        switch tag {
        case 0:
            selectedViewController = controllers[0]
        case 1:
            Canvas.renderSize = .init(width: 1080, height: 1080)
            let projectCreatingVC = ProjectCreatingViewController()
            projectCreatingVC.modalPresentationStyle = .fullScreen
            present(projectCreatingVC, animated: true)
        case 2:
            selectedViewController = controllers[1]
        default:
            break
        }
    }
}

extension RoundedTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view else { return false }
        guard let toView = viewController.view else { return false }
        
        if fromView != toView {
            UIView.transition(
                from: fromView,
                to: toView,
                duration: 0.25,
                options: [.transitionCrossDissolve]
            )
        }
        
        return true
    }
}
