//
//  ProjectsOptionsView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 19.04.2022.
//

import UIKit

final class NavigationView: UIView {
    
    enum TrailingButtonMode {
        case none, settings, folderEdit
    }
    
    var trailingButtonMode = TrailingButtonMode.settings {
        didSet {
            switch trailingButtonMode {
            case .none:
                trailingButton.isHidden = true
                trailingButton.isUserInteractionEnabled = false
            case .settings:
                trailingButton.isHidden = false
                trailingButton.isUserInteractionEnabled = true
                trailingButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
            case .folderEdit:
                trailingButton.isHidden = false
                trailingButton.tintColor = .appAccent
                trailingButton.showsMenuAsPrimaryAction = true
                trailingButton.isUserInteractionEnabled = true
                trailingButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
            }
        }
    }

    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }

    var titleLabel: UILabel!
    var trailingButton: UIButton!
    
    var hidesSettingsButton = false {
        didSet {
            trailingButton.isHidden = hidesSettingsButton
        }
    }
    
    var onSettingsButtonTapped: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        titleLabel = UILabel()
        titleLabel.text = "Projects"
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 32)
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        titleLabel.textColor = .label
        titleLabel.sizeToFit()
        
        trailingButton = UIButton()
        trailingButton.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        trailingButton.tintColor = .gray
        trailingButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        addSubview(trailingButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame.origin.x = 30
        titleLabel.frame.size.height = bounds.height
        
        trailingButton.frame = .init(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func settingsButtonTapped(_ sender: Any) {
        onSettingsButtonTapped?()
    }
    
    func setMenuForTrailingButton(_ menu: UIMenu) {
        trailingButton.menu = menu
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
        button.setTitleColor(.label, for: .normal)
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
	
	var allowsBorderSelection = true
	
	var selectedIndex = 0 {
		didSet {
			if allowsBorderSelection {
				for button in stackView.arrangedSubviews {
					if button.tag != selectedIndex {
						(button as? UIButton)?.layer.borderColor = UIColor.darkGray.cgColor
						(button as? UIButton)?.setTitleColor(.label, for: .normal)
					} else {
						(button as? UIButton)?.layer.borderColor = UIColor.appAccent.cgColor
						(button as? UIButton)?.setTitleColor(.appAccent, for: .normal)
					}
				}
			}
		}
	}
	
    private var stackView: UIStackView!
    private var tagForButton = 0
	
	func setTitles(_ titles: [String]) {
		guard titles.count == stackView.arrangedSubviews.count else { return }
		for (index, view) in stackView.arrangedSubviews.enumerated() {
			(view as? UIButton)?.setTitle(titles[index], for: .normal)
		}
	}
    
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
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        stackView.spacing = 10
        stackView.distribution = .fillEqually
    }
    
    func set(title: String, index: Int) {
        (stackView.arrangedSubviews[index] as? UIButton)?.setTitle(title, for: .normal)
    }
    
    func set(state: Bool, for index: Int) {
        stackView.arrangedSubviews[index].alpha = state ? 1 : 0.5
        stackView.arrangedSubviews[index].isUserInteractionEnabled = state
    }
    
    private func getButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 15)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapOption(_:)), for: .touchUpInside)
        button.tag = tagForButton
        tagForButton += 1
        return button
    }
    
    @objc private func didTapOption(_ sender: UIButton) {
		selectedIndex = sender.tag
        delegate?.didTapOption(tag: sender.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
