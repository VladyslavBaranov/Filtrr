//
//  StoreRefresh.swift
//  Flitrr
//
//  Created by Vladyslav Baranov on 21.05.2022.
//

import StoreKit

final class StoreRefresh: NSObject {
    
    private var refreshRequest: SKReceiptRefreshRequest!
    
    override init() {
        super.init()
        refreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
        refreshRequest.delegate = self
        refreshRequest.start()
        print("STARTED REFERESH")
    }
}

extension StoreRefresh: SKRequestDelegate {
    func requestDidFinish(_ request: SKRequest) {
        //guard let refreshRequest = request as? SKReceiptRefreshRequest else { return }
        //print(refreshRequest.receiptProperties)
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error.localizedDescription)
        print("FAILED")
    }
}
