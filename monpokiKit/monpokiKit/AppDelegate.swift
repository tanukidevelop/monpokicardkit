//
//  AppDelegate.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/05/30.
//

import UIKit
import GoogleMobileAds // 追加
import StoreKit



@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Google Mobile Ads SDKの初期化
        GADMobileAds.sharedInstance().start(completionHandler: nil) // 追加
        
        // スリープしない
        UIApplication.shared.isIdleTimerDisabled = true

        
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            } else {
                print("通知が許可されていない")
            }
        }
        
        
        // オブザーバー登録
        SKPaymentQueue.default().add(PurchaseProduct.shared)
        
        // 購入済みかどうか確認して、購入していない場合はアイテムが購入可能なのか確認する。
        if (!AppStoreClass.shared.isPurchased()) {
            AppStoreClass.shared.AdBlockFromAppStoreExists()
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // オブザーバー登録解除
        SKPaymentQueue.default().remove(PurchaseProduct.shared)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate{
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       // アプリ起動中でもアラートと音で通知
       completionHandler([.alert, .sound])
       
   }
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       completionHandler()
       
   }
}

