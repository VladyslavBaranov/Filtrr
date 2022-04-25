//
//  Fonts.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 22.04.2022.
//

import UIKit

struct Montserrat {
    static func light(size: CGFloat) -> UIFont {
        UIFont(name: "Montserrat-Light", size: size) ?? .systemFont(ofSize: size)
    }
    static func regular(size: CGFloat) -> UIFont {
        UIFont(name: "Montserrat-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    static func medium(size: CGFloat) -> UIFont {
        UIFont(name: "Montserrat-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    static func semibold(size: CGFloat) -> UIFont {
        UIFont(name: "Montserrat-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    static func bold(size: CGFloat) -> UIFont {
        UIFont(name: "Montserrat-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
