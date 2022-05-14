//
//  StoreHelper.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 14.05.2022.
//

import StoreKit

class StoreHelper: ObservableObject {
    
    @Published private(set) var products: [Product]?
    
    init() {
        guard let products = InAppConfiguration.readConfigFile() else { return }
        let task = Task {
            self.products = await requestProductsFromAppStore(products: products)
        }
    }
    
    @MainActor func requestProductsFromAppStore(products: Set<String>) async -> [Product]? {
        try? await Product.products(for: products)
    }
    
}
