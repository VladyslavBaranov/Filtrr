//
//  StoreHelper.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 14.05.2022.
//

import StoreKit

class AppProduct {
    
    var index: Int = 0
    var skProduct: SKProduct!
    var isSelected = false
    
    func getPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = skProduct.priceLocale
        return formatter.string(from: skProduct.price) ?? ""
    }
    
    func getTitle() -> String {
        switch skProduct.productIdentifier {
        case "com.year.subscription":
            return LocalizationManager.shared.localizedString(for: .settingsYearTitle)
        case "com.6months.subscription":
            return LocalizationManager.shared.localizedString(for: .settings6MonthTitle)
        default:
            return LocalizationManager.shared.localizedString(for: .settingsMonthTitle)
        }
    }
    
    func getSubtitle() -> String {
        switch skProduct.productIdentifier {
        case "com.year.subscription":
            return LocalizationManager.shared.localizedString(for: .settingsYearCaption)
        case "com.6months.subscription":
            return LocalizationManager.shared.localizedString(for: .settings6MonthCapion)
        default:
            return LocalizationManager.shared.localizedString(for: .settingsMonthCaption)
        }
    }
    
    func getDescription() -> String {
        switch skProduct.productIdentifier {
        case "com.year.subscription":
            return LocalizationManager.shared.localizedString(for: .settingsYearPriceFull)
        case "com.6months.subscription":
            return LocalizationManager.shared.localizedString(for: .settings6MonthCapion)
        default:
            return ""
        }
    }
}

class StoreHelper: NSObject, ObservableObject {

    private var request: SKProductsRequest!
    @Published private(set) var products = [AppProduct]()
    
    override init() {
        super.init()
        guard let products = InAppConfiguration.readConfigFile() else { return }
        request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        print("STARTED")
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
        var prods: [AppProduct] = []
        if !response.products.isEmpty {
            for (i, prod) in response.products.enumerated() {
                let pr = AppProduct()
                pr.skProduct = prod
                pr.index = i
                pr.isSelected = i == 0
                prods.append(pr)
            }
        }
        DispatchQueue.main.async { [unowned self] in
            self.products = prods
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("FAILED")
    }
}
