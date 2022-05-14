//
//  InAppConfiguration.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 14.05.2022.
//

import Foundation

struct InAppConfiguration {
    
    private init() {}
    
    static func readConfigFile() -> Set<String>? {
        guard let path = Bundle.main.url(forResource: "iAps", withExtension: "plist") else { return nil }
        guard let contents = NSDictionary(contentsOf: path) as? [String: AnyObject] else { return nil }
        guard let items = contents["Products"] as? Array<String> else { return nil }
        return Set(items)
    }
    
}
