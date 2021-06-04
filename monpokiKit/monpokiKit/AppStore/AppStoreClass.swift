//
//  AppStoreClass.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/06/03.
//

import Foundation
import StoreKit
import SwiftyStoreKit

final class AppStoreClass {
    private init() {}
    static let shared = AppStoreClass()
    
    // 購入済みかどうか確認する
    var isPurchased = false
    let addBlockProductId = "addBlock"  // 広告非表示機能
    
    func isPurchasedWhenAppStart() {
        if (UserDefaults.standard.bool(forKey:"isPurchased")) {
            isPurchased = true
        } else {
            restore()
        }
    }
    func buyAdBlockFromAppStore() {
        SwiftyStoreKit.purchaseProduct("adBlock", quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                            
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                @unknown default: break
                }
            }
        }
    }
    
    // 購入
    func purchaseProduct(_ productIdentifier: String) {

    }
    
    func restore() {
        SwiftyStoreKit.restorePurchases(atomically: true) { result in
            for product in result.restoredPurchases {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
                if product.productId == "adBlock" {
                    // プロダクトID1のリストア後の処理を記述する
                    self.isPurchased = true
                    UserDefaults.standard.set(true, forKey:"isPurchased")
                } else {
                    self.isPurchased = false
                }
                
            }
        }
    }

     
}

