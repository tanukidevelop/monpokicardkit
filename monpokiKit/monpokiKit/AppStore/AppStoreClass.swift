//
//  AppStoreClass.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/06/03.
//

import Foundation
import StoreKit

final class AppStoreClass {
    private init() {}
    static let shared = AppStoreClass()
    
    // 購入可能かどうかをチェックする。初期値はfalase
    var isPurchasable = false
    var products : [SKProduct] = []
    let addBlockProductId = "addBlock"
    
    func isPurchased() -> Bool {
        let isPurchased = UserDefaults.standard.bool(forKey: "isPurchased")
        return isPurchased
    }
    
    func AdBlockFromAppStoreExists(){
        // 商品情報を取得する
        DownloadProduct.shared.callAsFunction(productIds: [addBlockProductId])
    }
    
    func buyAdBlockFromAppStore() {
        if (isPurchased()) {
            purchaseProduct(addBlockProductId)
        }
    }
    
    // 購入
    func purchaseProduct(_ productIdentifier: String) {
        // productIdentifierに該当するproduct情報があるかチェック
        guard let product = productForIdentifiers(productIdentifier) else { return }
        // 購入リクエスト
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    // 該当のproduct情報はproductsに存在するか確認
    private func productForIdentifiers(_ productIdentifier: String) -> SKProduct? {
        return products.filter({ (product: SKProduct) -> Bool in
            return product.productIdentifier == productIdentifier
        }).first
    }
     
}

