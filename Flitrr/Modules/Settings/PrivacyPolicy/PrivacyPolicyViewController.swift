//
//  PrivacyPolicyViewController.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 22.04.2022.
//

import SwiftUI

struct PrivacyPolicyView: UIViewControllerRepresentable {
    let mode: PrivacyPolicyViewController.Mode
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = PrivacyPolicyViewController()
        print("#CREATE", mode.rawValue)
        controller.mode = mode
        controller.showsCloseButton = false
        return controller
    }
}

final class PrivacyPolicyViewController: UIViewController {
    
    enum Mode: String { case termsOfUse = "TermsOfUse", privacyPolicy = "PrivacyPolicy" }
    
    var mode: Mode = .privacyPolicy
    
    var showsCloseButton: Bool = true
    private var gradientLayer: CAGradientLayer!
    private var closeButton: UIButton!
    var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalizationManager.shared.localizedString(for: .settingsPrivacy)
        
        view.backgroundColor = .appDark
        textView = UITextView()
        textView.contentInset = .init(top: 80, left: 30, bottom: 30, right: 30)
        textView.backgroundColor = .appDark
        textView.textColor = .label
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont(name: "Montserrat-Regular", size: 15)
        
        view.addSubview(textView)
        
        setupCloseButton()
        print(mode.rawValue)
        guard let file = Bundle.main.url(forResource: mode.rawValue, withExtension: "rtf") else { return }
        guard let string = try? NSMutableAttributedString(
            url: file,
            options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil) else { return }
        string.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.label, range: .init(location: 0, length: string.string.count))
        textView.attributedText = string
        
        setupGradient()
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
    
    func setupCloseButton() {
        closeButton = UIButton(type: .close)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        closeButton.isHidden = !showsCloseButton
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = .init(
            x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        gradientLayer.frame = .init(x: 0, y: 0, width: view.bounds.width, height: view.safeAreaInsets.top + 80)
    }
}
