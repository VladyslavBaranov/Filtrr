//
//  GraphicsStretchyHeader.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 13.05.2022.
//

import UIKit

protocol GraphicsStretchyHeaderDelegate: AnyObject {
    func didTapBackButton()
}

final class GraphicsStretchyHeader: UIView {
    
    weak var delegate: GraphicsStretchyHeaderDelegate!
    var imageView: UIImageView!
    var dimImageView: UIImageView!
    var gradientLayer: CAGradientLayer!
    
    var backButton: UIButton!
    private var titleLabel: UILabel!
    var countLabel: UILabel!
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        countLabel.frame.origin = .init(x: 20, y: bounds.height - 20 - countLabel.bounds.height)
        titleLabel.frame.origin = .init(x: 20, y: countLabel.frame.minY - titleLabel.bounds.height)
        dimImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleBackAction() {
        delegate?.didTapBackButton()
    }
    
    func setupUI() {
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        dimImageView = UIImageView(image: UIImage(named: "Dim"))
        addSubview(dimImageView)
        
        titleLabel = UILabel()
        titleLabel.font = Montserrat.bold(size: 32)
        titleLabel.textColor = .white
        titleLabel.text = "Summer Jam"
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        countLabel = UILabel()
        countLabel.font = Montserrat.medium(size: 17)
        countLabel.text = "32 graphics"
        countLabel.textColor = .white
        countLabel.sizeToFit()
        addSubview(countLabel)
        
        countLabel.frame.origin = .init(x: 20, y: bounds.height - 20 - countLabel.bounds.height)
        titleLabel.frame.origin = .init(x: 20, y: countLabel.frame.minY - titleLabel.bounds.height)
        
        backButton = UIButton(frame: .init(x: 30, y: 50, width: 30, height: 30))
        backButton.setImage(UIImage(named: "Back"), for: .normal)
        backButton.overrideUserInterfaceStyle = .dark
        backButton.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
        addSubview(backButton)
    }
}
