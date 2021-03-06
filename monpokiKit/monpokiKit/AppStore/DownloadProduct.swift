//
//  DownloadProduct.swift
//  InAppPurchaseSample
//
//  Created by uematsushun on 2020/09/25.
//

import Foundation
import StoreKit


// https://zenn.dev/ueshun/articles/2cd4b20b049b76eb26de
enum DownloadProductError: Error {
	case noProduct
	case invalidProduct
	
	var message: String {
		switch self {
			case .noProduct: return "No items available for purchase. Make sure the product ID is correct."
			case .invalidProduct: return "There is an invalid product."
		}
	}
}

protocol DownloadedProductNotification: AnyObject {
	/// Notify donwloaded product.
	/// - Parameters:
	///   - products: SKProduct
	///   - error: Error
	func downloaded(products: [SKProduct]?, error: Error?)
}

final class DownloadProduct: NSObject {
	static let shared = DownloadProduct()
	
	private override init() { }
	
	private var productsRequest: SKProductsRequest?
	
	weak var delegate: DownloadedProductNotification?
	
	func callAsFunction(productIds: Set<String>) {
		productsRequest = SKProductsRequest(productIdentifiers: Set(productIds))
		productsRequest?.delegate = self
		productsRequest?.start()
	}
}

extension DownloadProduct: SKProductsRequestDelegate {
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products.isEmpty)
		guard response.products.isEmpty else {
            // 空ではない場合
			delegate?.downloaded(products: nil, error: DownloadProductError.noProduct)
            AppStoreClass.shared.isPurchasable = true
            AppStoreClass.shared.products = response.products
			return
		}
		
		guard response.invalidProductIdentifiers.isEmpty else {
			delegate?.downloaded(products: nil, error: DownloadProductError.invalidProduct)
            AppStoreClass.shared.isPurchasable = true
            AppStoreClass.shared.products = response.products

			return
		}
		
		delegate?.downloaded(products: response.products, error: nil)
	}
}
