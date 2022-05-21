//
//  AdjustableLabel.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 08.05.2022.
//

import UIKit

final class AdjustableLabel: AdjustableView {
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        addSubview(label)
        label.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    override func render(in ctx: CGContext, factor: CGPoint) {
        ctx.move(to: frame.origin)
        
        let frame = CGRect(
            x: frame.origin.x * factor.x,
            y: frame.origin.y * factor.y,
            width: frame.width * factor.x,
            height: frame.height * factor.y)
        
        label.attributedText?.draw(
            in: frame)
    }
    
    static func createLabel(for attributedString: NSAttributedString) -> AdjustableLabel {
        let label = AdjustableLabel(frame: .init(origin: .zero, size: attributedString.size()))
        label.label.attributedText = attributedString
        return label
    }
}
