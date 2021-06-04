//
//  KitViewController.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/05/30.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds


class KitViewController: UIViewController {
    private var interstitial: GADInterstitialAd?
    
    var addTimer = Timer()
    let disposeBag = DisposeBag()
    
    
    var kitView : KitView?
    var kitModel = KitModel()
    
    var playerOneTableView = TableViewController()
    var playerTwoTableView = TableViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppStoreClass.shared.isPurchasedWhenAppStart()

        // StoryboardでのTweetViewControllerの親ViewがTweetListViewなので取得できる。
        guard let kitView = view as? KitView else { return }
        self.kitView = kitView
        
        loadTableView()

        kitView.settingsButton.rx.tap.subscribe({ [weak self] _ in
            let actionSheet = UIAlertController(title: "設定",
                                                message: nil,
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "広告非表示機能を復元", style: .default, handler: { (action:UIAlertAction) in
                AppStoreClass.shared.restore { isSuccess in
                    if (isSuccess) {
                        self?.showAlertControllerAutoDelete(massage: "復元に成功しました。")
                    } else {
                        self?.showAlertControllerAutoDelete(massage: "復元に失敗しました。広告非表示機能が購入されていません。")
                    }
                }
            }))
            
            if (!AppStoreClass.shared.isPurchased) {
                actionSheet.addAction(UIAlertAction(title: "広告非表示機能を購入", style: .default, handler: { (action:UIAlertAction) in
                    AppStoreClass.shared.purchaseItemFromAppStore(productId: "adBlock")
                }))
            }

            
            // iPad の場合のみ、ActionSheetを表示するための必要な設定
            if UIDevice.current.userInterfaceIdiom == .pad {
                actionSheet.popoverPresentationController?.sourceView =  kitView.settingsButton
                let screenSize = UIScreen.main.bounds
                actionSheet.popoverPresentationController?.sourceRect =  kitView.settingsButton.frame
            }
            
            self?.present(actionSheet, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
        
        kitView.reloadButton.rx.tap.subscribe({ [weak self] _ in
            self?.kitView?.gx1pSwitch.setOn(false, animated: false)
            self?.kitView?.gx2pSwitch.setOn(false, animated: false)
            self?.playerOneTableView.tableViewModel.resetGame()
            self?.playerTwoTableView.tableViewModel.resetGame()
            self?.playerOneTableView.tableView.reloadData()
            self?.playerTwoTableView.tableView.reloadData()
            
            self?.showAdMob()
        }).disposed(by: disposeBag)
        
        kitView.cointossButton.rx.tap.subscribe({ [weak self] _ in
            self?.pleaseAllowNotification()
            
            let content = UNMutableNotificationContent()
            content.title = "お知らせ"
            var cointossMsgList: [String] = ["コイントス：「おもて」がでました。", "コイントス：「うら」がでました。"]
            content.body = cointossMsgList.randomElement()!
            content.sound = UNNotificationSound.default
            
            // 直ぐに通知を表示
            let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            self?.showAdMob()
        }).disposed(by: disposeBag)
        
        kitView.jankenButton.rx.tap.subscribe({ [weak self] _ in
            self?.pleaseAllowNotification()

            let content = UNMutableNotificationContent()
            content.title = "お知らせ"
            var jankenMsgList: [String] = ["プレイヤー1がじゃんけんに勝ちました。", "プレイヤー2がじゃんけんに勝ちました。"]
            content.body = jankenMsgList.randomElement()!
            content.sound = UNNotificationSound.default
            
            // 直ぐに通知を表示
            let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            self?.showAdMob()
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func requestShowAdMob() {
        let request = GADRequest()
        
        // adId:ca-app-pub-7248782092625183/3345264085
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-7248782092625183/3345264085",
                               request: request,
                               completionHandler: { [self] ad, error in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                interstitial = ad
                                if self.interstitial != nil {
                                    self.interstitial!.present(fromRootViewController: self)
                                } else {
                                    print("Ad wasn't ready")
                                }
                               }
                               
        )
    }
    
    func showAdMob() {
        // 広告課金済みなら広告を表示しない
        if (AppStoreClass.shared.isPurchased) { return}
 
        addTimer.invalidate()
        //timer処理
        addTimer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true, block: { (timer) in
            self.requestShowAdMob()
        })
    }
    
    func pleaseAllowNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
            if error != nil {
                return
            }
            
            if granted {
                debugPrint("通知許可")
            } else {
                let alert = UIAlertController(title: "通知が許可されていません", message: "コイントス、じゃんけん機能はアプリ内のプッシュ通知を利用します。設定アプリ>通知から通知を全て許可してください。", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "閉じる", style: .default, handler: { (UIAlertAction) in
                })
                alert.addAction(yesAction)
                
                DispatchQueue.main.async {
                    // メインスレッドで実行 UIの処理など
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    func loadTableView() {
        playerOneTableView.tableViewModel.resetGame()
        playerTwoTableView.tableViewModel.resetGame()
        
        self.kitView?.playerOneView.frame = playerOneTableView.view.frame
        self.kitView?.playerTwoView.frame = playerTwoTableView.view.frame
        self.kitView?.playerOneView?.addSubview(playerOneTableView.view!)
        self.kitView?.playerTwoView?.addSubview(playerTwoTableView.view!)
    }
    
    
    // 自動で消えるAlertControllerを表示する
    func showAlertControllerAutoDelete(massage: String) {
        let alertController = UIAlertController(title: nil, message: massage, preferredStyle: .alert)
        // Default のaction
        let defaultAction:UIAlertAction =
                    UIAlertAction(title: "閉じる",
                          style: .default,
                          handler:{
                            (action:UIAlertAction!) -> Void in
                            // 処理
                            alertController.dismiss(animated: true, completion: nil)
                })
        alertController.addAction(defaultAction)

        self.present(alertController, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            //ここに処理
            alertController.dismiss(animated: true, completion: nil)
        }
        
    }


}
