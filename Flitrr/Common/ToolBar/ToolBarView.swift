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
        case back, cancel
    }
    
    enum TrailingItem {
        case share, confirm
    }
    
    enum CenterItem {
        case title, editSet
    }
    
	var leadingItem: LeadingItem = .back {
		didSet {
			if leadingItem == .back {
				leadingButton.setImage(.init(named: "Back"), for: .normal)
			} else {
				leadingButton.setImage(.init(named: "Cancel"), for: .normal)
			}
		}
	}
	
	var trailingItem: TrailingItem = .share {
		didSet {
			if trailingItem == .share {
				trailingButton.setImage(.init(named: "Share"), for: .normal)
			} else {
				trailingButton.setImage(.init(named: "Check"), for: .normal)
			}
		}
	}
	
    var centerItem: CenterItem = .title
    var title: String? {
        didSet {
            if centerItem == .title {
                titleLabel.text = title
				titleLabel.sizeToFit()
            }
        }
    }
    
    private var leadingButton: UIButton!
    private var trailingButton: UIButton!
    
    private var titleLabel: UILabel!
    
    private var toolsStack: UIStackView!
    private var undoButton: UIButton!
    private var redoButton: UIButton!
    private var layersButton: UIButton!
    
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
        
        if centerItem == .title {
            titleLabel = UILabel()
			titleLabel.textAlignment = .center
            titleLabel.textColor = .white
            titleLabel.font = Montserrat.medium(size: 17)
            addSubview(titleLabel)
        } else {
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
        
        leadingButton.addTarget(self, action: #selector(leadingButtonTapped), for: .touchUpInside)
        trailingButton.addTarget(self, action: #selector(trailingButtonTapped), for: .touchUpInside)
        layersButton?.addTarget(self, action: #selector(layerButtonTapped), for: .touchUpInside)
        undoButton?.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        redoButton?.addTarget(self, action: #selector(redoButtonTapped), for: .touchUpInside)
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
