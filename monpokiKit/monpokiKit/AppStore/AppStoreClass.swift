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

    // 購入済みを保存する
    func savePurchased() {
        self.isPurchased = true
        UserDefaults.standard.set(self.isPurchased, forKey: "isPurchased")
    }
    
    // 購入済みかどうかを読み込んで確認する
    func loadPurchased() {
        let isPurchased = UserDefaults.standard.bool(forKey: "isPurchased")
        self.isPurchased = isPurchased
    }
    
    func getProductInfo()  {
        SwiftyStoreKit.retrieveProductsInfo([StructConstaints.PRODUCT_ID]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }
    
    // 購入
    func purchaseItemFromAppStore(productId: String) {
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                AppStoreClass.shared.savePurchased()
                
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
    
    // リストア
    func restore(isSuceess: @escaping (Bool) -> Void ) {
        SwiftyStoreKit.restorePurchases(atomically: true) { result in
            for product in result.restoredPurchases {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
                if product.productId == StructConstaints.PRODUCT_ID {
                    // プロダクトID1のリストア後の処理を記述する
                    self.isPurchased = true
                    AppStoreClass.shared.savePurchased()
                    isSuceess(true)
                    return
                } else {
                    self.isPurchased = false
                    isSuceess(false)
                    return
                }
            }
            isSuceess(false)
        }
    }
}

