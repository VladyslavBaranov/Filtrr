//
//  PropertyWrappers.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 19.04.2022.
//

import UIKit

@propertyWrapper struct MontserratLabel<Value: UILabel> {
    
    enum FontWeight: String {
        case regular = "Montserrat-Regular"
        case medium = "Montserrat-Medium"
        case bold = "Montserrat-Bold"
    }
    
    var size: CGFloat
    var fontWeight: FontWeight
    
    var wrappedValue: UILabel {
        didSet {
            wrappedValue.font = UIFont(name: fontWeight.rawValue, size: size)
        }
    }
    init(size: CGFloat, fontWeight: FontWeight) {
        self.wrappedValue = Value()
        self.size = size
        self.fontWeight = fontWeight
        self.wrappedValue.font = UIFont(name: fontWeight.rawValue, size: size)
    }
}
