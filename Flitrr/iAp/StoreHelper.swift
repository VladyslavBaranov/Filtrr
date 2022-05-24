//
//  StoreHelper.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 14.05.2022.
//

import StoreKit

class AppProduct {
    
    var price: Float = 0.0
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
        case "com.year.renewable":
            return LocalizationManager.shared.localizedString(for: .settingsYearTitle)
        case "com.6months.renewable":
            return LocalizationManager.shared.localizedString(for: .settings6MonthTitle)
        default:
            return LocalizationManager.shared.localizedString(for: .settingsMonthTitle)
        }
    }
    
    func getSubtitle() -> String {
        switch skProduct.productIdentifier {
        case "com.year.renewable":
            return LocalizationManager.shared.localizedString(for: .settingsYearCaption)
        case "com.6months.renewable":
            return LocalizationManager.shared.localizedString(for: .settings6MonthCapion)
        default:
            return LocalizationManager.shared.localizedString(for: .settingsMonthCaption)
        }
    }
    
    func getDescription() -> String {
        switch skProduct.productIdentifier {
        case "com.year.renewable":
            return LocalizationManager.shared.localizedString(for: .settingsYearPriceFull)
                .replacingOccurrences(of: "@", with: "\(getPrice())")
        case "com.6months.renewable":
            return LocalizationManager.shared.localizedString(for: .settings6MonthFull)
                .replacingOccurrences(of: "@", with: "\(getPrice())")
        default:
            return ""
        }
    }
    
    func getMonthlyPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = skProduct.priceLocale

        switch skProduct.productIdentifier {
        case "com.year.renewable":
            return formatter.string(from: NSNumber(value: price / 12.0)) ?? ""
        case "com.6months.renewable":
            return formatter.string(from: NSNumber(value: price / 6.0)) ?? ""
        default:
            return formatter.string(from: NSNumber(value: price)) ?? ""
        }
    }
}

class StoreHelper: NSObject, ObservableObject {

    private var request: SKProductsRequest!
    @Published private(set) var products = [AppProduct]()
    
    func getSelectedProduct() -> AppProduct {
        products.first(where: { $0.isSelected })!
    }
    
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
        var prods: [AppProduct] = []
        if !response.products.isEmpty {
            for (i, prod) in response.products.enumerated() {
                let pr = AppProduct()
                pr.skProduct = prod
                pr.isSelected = i == 0
                pr.price = prod.price.floatValue
                prods.append(pr)
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.products = prods.sorted {
                    $0.skProduct.price.doubleValue > $1.skProduct.price.doubleValue
                }
                for i in 0..<products.count {
                    products[i].index = i
                }
            }
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
    }
}
