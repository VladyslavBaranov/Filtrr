//
//  AppState.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 14.05.2022.
//

import Foundation
import UIKit

extension UIUserInterfaceStyle {
    var index: Int {
        switch self {
        case .unspecified:
            return 2
        case .light:
            return 0
        case .dark:
            return 1
        @unknown default:
            return 2
        }
    }
}

final class AppState {
    
    enum Key: String {
        case appearanceIcon
        case appearanceTheme
    }
    
    static let shared = AppState()
    
    func set(_ string: String, forKey key: Key) {
        UserDefaults.standard.set(string, forKey: key.rawValue)
    }
    
    func string(forKey key: Key) -> String {
        UserDefaults.standard.value(forKey: key.rawValue) as? String ?? ""
    }
    
    func set(_ style: UIUserInterfaceStyle) {
        UserDefaults.standard.set(style.index, forKey: Key.appearanceTheme.rawValue)
    }
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        guard let int = UserDefaults.standard.value(forKey: Key.appearanceTheme.rawValue) as? Int else {
            return .unspecified
        }
        if int == 0 {
            return .light
        } else if int == 1 {
            return .dark
        }
        return .unspecified
    }
}
