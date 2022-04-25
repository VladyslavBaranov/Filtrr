//
//  ProjectsOptionsView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 19.04.2022.
//

import UIKit

final class NavigationView: UIView {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
    
    var titleLabel: UILabel!
    var settingsButton: UIButton!
    var onSettingsButtonTapped: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        titleLabel = UILabel()
        titleLabel.text = "Projects"
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 32)
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        
        settingsButton = UIButton()
        settingsButton.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .gray
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        addSubview(settingsButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame.origin.x = 30
        titleLabel.frame.size.height = bounds.height
        
        settingsButton.frame = .init(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func settingsButtonTapped(_ sender: Any) {
        onSettingsButtonTapped?()
    }
}

final class ProjectsOptionsView: UIView {
    
    private var index: CGFloat = 0.0
    var spacing: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton(title: "Projects")
        addButton(title: "Folders")
        addButton(title: "Select")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButton(title: String) {
        let bWidth = (bounds.width - 4 * spacing) / 3
        let button = UIButton(frame: .init(
            x: index * bWidth + spacing * (index + 1),
            y: 0,
            width: bWidth,
            height: bounds.height)
        )
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 15)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        addSubview(button)
        button.layer.cornerRadius = 8
        index += 1
    }
}

protocol ProjectsOptionsContainerViewDelegate: AnyObject {
    func didTapOption(tag: Int)
}

final class ProjectsOptionsContainerView: UIView {
    
    weak var delegate: ProjectsOptionsContainerViewDelegate!
    var stackView: UIStackView!
    
    var tagForButton = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView = UIStackView(arrangedSubviews: [
            getButton(title: "Projects"),
            getButton(title: "Folders"),
            getButton(title: "Select")
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 40),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40)
        ])
        stackView.spacing = 10
        stackView.distribution = .fillEqually
    }
    
    func getButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.appAccent, for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 15)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.appAccent.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapOption(_:)), for: .touchUpInside)
        button.tag = tagForButton
        tagForButton += 1
        return button
    }
    
    @objc func didTapOption(_ sender: UIButton) {
        sender.setTitleColor(.appAccent, for: .normal)
        sender.layer.borderColor = UIColor.appAccent.cgColor
        for button in stackView.arrangedSubviews {
            if button.tag != sender.tag {
                (button as? UIButton)?.layer.borderColor = UIColor.darkGray.cgColor
                (button as? UIButton)?.setTitleColor(.white, for: .normal)
            }
        }
        delegate?.didTapOption(tag: sender.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
