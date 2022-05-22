//
//  UIApplication.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 22.05.2022.
//

import UIKit

extension UIApplication {
    func getStatusBarHeight() -> CGFloat {
        (connectedScenes.first as? UIWindowScene)?
            .statusBarManager?
            .statusBarFrame
            .height ?? 0
    }
}
