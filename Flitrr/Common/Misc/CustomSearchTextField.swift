//
//  CustomSearchTextField.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 07.05.2022.
//

import UIKit

final class CustomSearchTextField: UISearchTextField {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        .init(x: 0, y: 0, width: bounds.height, height: bounds.height)
    }
}
 
