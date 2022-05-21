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
    
    func buy(_ product: AppProduct) {
        guard SKPaymentQueue.canMakePayments() else { return }
        let payment = SKPayment(product: product.skProduct)
        SKPaymentQueue.default().add(payment)
    }
    
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
    
    func receiptValidation(_ expirationDate: @escaping (Date?) -> ()) {
        let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let jsonDict: [String: AnyObject] = [
            "receipt-data": recieptString! as AnyObject,
            "password": "787ca6b864714cdea4ed6d55802d1fe4" as AnyObject
        ]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("Response :",jsonResponse)
                        if let date = self?.getExpirationDateFromResponse(jsonResponse) {
                            expirationDate(date)
                        }
                    }
                } catch let parseError {
                    print(parseError)
                }
            })
            task.resume()
        } catch let parseError {
            print(parseError)
        }
    }
    
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            return nil
        }
        else {
            return nil
        }
    }
    
}
