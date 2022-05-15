//
//  StoreObserver.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 15.05.2022.
//

import StoreKit

final class StoreObserver: NSObject, SKPaymentTransactionObserver {
    
    static let shared = StoreObserver()
    
    var finishedCallback: (() -> ())?
    
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                finishedCallback?()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                finishedCallback?()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                break
            @unknown default:
                break
            }
        }
    }
}
