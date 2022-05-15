//
//  StoreHelper.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 14.05.2022.
//

import StoreKit

class StoreHelper: NSObject, ObservableObject {

    private var request: SKProductsRequest!
    @Published private(set) var products = [SKProduct]()
    
    override init() {
        super.init()
        guard let products = InAppConfiguration.readConfigFile() else { return }
        request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
    }

    func buy(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restore() {
        StoreObserver.shared.restore()
    }
}

extension StoreHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !response.products.isEmpty {
            products = response.products
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("FAILED")
    }
}
