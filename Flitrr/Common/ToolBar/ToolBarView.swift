//
//  ToolBarView.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 23.04.2022.
//

import UIKit

protocol ToolBarViewDelegate: AnyObject {
    func didTapTrailingItem()
    func didTapLeadingItem()
    
    func didTapUndo()
    func didTapLayers()
    func didTapRedo()
}

final class ToolBarView: UIView {
    
    weak var delegate: ToolBarViewDelegate!
    
    enum LeadingItem {
        case back, cancel, none
    }
    
    enum TrailingItem {
        case share, confirm, none
    }
    
    enum CenterItem {
        case title, editSet, colorData
    }
    
	var leadingItem: LeadingItem = .back {
		didSet {
            leadingButton.isHidden = false
			if leadingItem == .back {
				leadingButton.setImage(.init(named: "Back"), for: .normal)
            } else if leadingItem == .none {
                leadingButton.isHidden = true
            } else {
				leadingButton.setImage(.init(named: "Cancel"), for: .normal)
			}
		}
	}
	
	var trailingItem: TrailingItem = .share {
		didSet {
            trailingButton.isHidden = false
			if trailingItem == .share {
				trailingButton.setImage(.init(named: "Share"), for: .normal)
            } else if trailingItem == .none {
                trailingButton.isHidden = true
            } else {
				trailingButton.setImage(.init(named: "Check"), for: .normal)
			}
		}
	}
	
    var centerItem: CenterItem = .title {
        didSet {
            setupCenterItem()
        }
    }
    
    var title: String? {
        didSet {
            if centerItem == .title {
                titleLabel.text = title
				titleLabel.sizeToFit()
            }
        }
    }
    
    private(set) var leadingButton: UIButton!
    private(set) var trailingButton: UIButton!
    
    private var titleLabel: UILabel!
    
    private var toolsStack: UIStackView!
    var undoButton: UIButton!
    var redoButton: UIButton!
    private var layersButton: UIButton!
	
	private var colorCircle: UIView!
    
    init(frame: CGRect, centerItem: CenterItem) {
        super.init(frame: frame)
        self.centerItem = centerItem
        setupUI()
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		titleLabel?.frame = bounds
	}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        setupSideButtons()
        setupCenterItem()

        leadingButton.addTarget(self, action: #selector(leadingButtonTapped), for: .touchUpInside)
        trailingButton.addTarget(self, action: #selector(trailingButtonTapped), for: .touchUpInside)
        layersButton?.addTarget(self, action: #selector(layerButtonTapped), for: .touchUpInside)
        undoButton?.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        redoButton?.addTarget(self, action: #selector(redoButtonTapped), for: .touchUpInside)
    }
	
	private func setupSideButtons() {
		leadingButton = UIButton()
		if leadingItem == .back {
			leadingButton.setImage(.init(named: "Back"), for: .normal)
		} else {
			leadingButton.setImage(.init(named: "Cancel"), for: .normal)
		}
		leadingButton.translatesAutoresizingMaskIntoConstraints = false
		addSubview(leadingButton)
		
		trailingButton = UIButton()
		trailingButton.translatesAutoresizingMaskIntoConstraints = false
		if trailingItem == .share {
			trailingButton.setImage(.init(named: "Share"), for: .normal)
		} else {
			trailingButton.setImage(.init(named: "Check"), for: .normal)
		}
		addSubview(trailingButton)
		
		NSLayoutConstraint.activate([
			trailingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
			leadingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			leadingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30)
		])
	}
	
	private func setupCenterItem() {
		switch centerItem {
		case .title:
            if titleLabel == nil {
                titleLabel = UILabel()
                titleLabel.textAlignment = .center
                titleLabel.textColor = .label
                titleLabel.font = Montserrat.medium(size: 17)
                addSubview(titleLabel)
            }
            if undoButton != nil {
                titleLabel.isHidden = false
                toolsStack.isHidden = true
            }
		case .editSet:
            if undoButton == nil {
                undoButton = UIButton()
                undoButton.setImage(.init(named: "Undo"), for: .normal)
                layersButton = UIButton()
                layersButton.setImage(.init(named: "Layers"), for: .normal)
                layersButton.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
                redoButton = UIButton()
                redoButton.setImage(.init(named: "Redo"), for: .normal)
                
                toolsStack = UIStackView(arrangedSubviews: [undoButton, layersButton, redoButton])
                toolsStack.spacing = 30
                toolsStack.translatesAutoresizingMaskIntoConstraints = false
                addSubview(toolsStack)
                
                NSLayoutConstraint.activate([
                    toolsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
                    toolsStack.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
            }
            if titleLabel != nil {
                titleLabel.isHidden = true
                toolsStack.isHidden = false
            }
		case .colorData:
			colorCircle = UIView()
			colorCircle.layer.cornerRadius = 15
			colorCircle.backgroundColor = .red
			
			titleLabel = UILabel()
			titleLabel.textAlignment = .center
			titleLabel.text = "#FF0000  %100"
			titleLabel.textColor = .label
			titleLabel.font = Montserrat.medium(size: 17)
			
			toolsStack = UIStackView(arrangedSubviews: [colorCircle, titleLabel])
			toolsStack.spacing = 10
			toolsStack.translatesAutoresizingMaskIntoConstraints = false
			addSubview(toolsStack)
			
			NSLayoutConstraint.activate([
				colorCircle.heightAnchor.constraint(equalToConstant: 30),
				colorCircle.widthAnchor.constraint(equalToConstant: 30),
				toolsStack.centerXAnchor.constraint(equalTo: centerXAnchor),
				toolsStack.centerYAnchor.constraint(equalTo: centerYAnchor)
			])
		}
	}
    
    func setUndoRedoState(_ manager: UndoManager) {
        redoButton.alpha = manager.canRedo ? 1 : 0.5
        undoButton.alpha = manager.canUndo ? 1 : 0.5
        
        redoButton.isEnabled = manager.canRedo
        undoButton.isEnabled = manager.canUndo
    }
	
	func setColor(_ uiColor: UIColor, alphaPercent: Int) {
		colorCircle.backgroundColor = uiColor
		titleLabel.text = "\(uiColor.hexString().uppercased())  \(alphaPercent)%"
	}
    
    @objc func leadingButtonTapped() {
        delegate?.didTapLeadingItem()
    }
    @objc func trailingButtonTapped() {
        delegate?.didTapTrailingItem()
    }
    @objc func layerButtonTapped() {
        delegate?.didTapLayers()
    }
    @objc func undoButtonTapped() {
        delegate?.didTapUndo()
    }
    @objc func redoButtonTapped() {
        delegate?.didTapRedo()
    }
}
