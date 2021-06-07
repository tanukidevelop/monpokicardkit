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
    let nogxmaker = UIImage(named:"gxmaker_off")
    let gxmakerused = UIImage(named:"gxmaker_used")

    
    var kitView : KitView?
    var kitModel = KitModel()
    
    var playerOneTableView = TableViewController()
    var playerTwoTableView = TableViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // StoryboardでのTweetViewControllerの親ViewがTweetListViewなので取得できる。
        guard let kitView = view as? KitView else { return }
        self.kitView = kitView
        
        loadTableView()

        
        kitView.GxMakerPlayerOne.image = nogxmaker
        kitView.GxMakerPlayerOneButton.rx.tap.subscribe({ [weak self] _ in
            if (kitView.GxMakerPlayerOne.image == self?.nogxmaker) {
                kitView.GxMakerPlayerOne.image = self?.gxmakerused
            } else {
                kitView.GxMakerPlayerOne.image = self?.nogxmaker
            }
        }).disposed(by: disposeBag)
        
        kitView.GxMakerPlayerTwo.image = nogxmaker
        kitView.GxMakerPlayerTwoButton.rx.tap.subscribe({ [weak self] _ in
            if (kitView.GxMakerPlayerTwo.image == self?.nogxmaker) {
                kitView.GxMakerPlayerTwo.image = self?.gxmakerused
            } else {
                kitView.GxMakerPlayerTwo.image = self?.nogxmaker
            }

        }).disposed(by: disposeBag)
        
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
                    AppStoreClass.shared.purchaseItemFromAppStore(productId: StructConstaints.PRODUCT_ID)
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
            self?.showAlertController(massage: "ゲーム状況をリセットしてよろしいでしょうか。")
            
            self?.showAdMob()
        }).disposed(by: disposeBag)
        
        kitView.cointossButton.rx.tap.subscribe({ [weak self] _ in
            var cointossMsgList: [String] = ["コイントス：「おもて」がでました。", "コイントス：「うら」がでました。"]
            let cointoss = cointossMsgList.randomElement()!
            
            self?.showAlertControllerAutoDelete(massage: cointoss)
            self?.showAdMob()

        }).disposed(by: disposeBag)
        
        kitView.jankenButton.rx.tap.subscribe({ [weak self] _ in
            var jankenMsgList: [String] = ["プレイヤー1がじゃんけんに勝ちました。", "プレイヤー2がじゃんけんに勝ちました。"]
            let janken = jankenMsgList.randomElement()!
            self?.showAlertControllerAutoDelete(massage: janken)
            self?.showAdMob()
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppStoreClass.shared.getProductInfo()
        UpgradeNotice.shared.fire()
    }
    
    func requestShowAdMob() {
        let request = GADRequest()
        
        // myAdmobID:ca-app-pub-7248782092625183/3345264085
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
        guard !(AppStoreClass.shared.isPurchased)  else {
            // 課金済みの場合はタイマー処理に行かせないで終える
            return
        }
        // 広告課金済みなら広告を表示しない
        addTimer.invalidate()
        //timer処理
        addTimer = Timer.scheduledTimer(withTimeInterval: 180.0, repeats: true, block: { (timer) in
            // クロージャの変数のキャプチャを考慮して広告表示自体の処理にもif文を設ける
            if (!AppStoreClass.shared.isPurchased) { self.requestShowAdMob() }
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
    
    func showAlertController(massage: String){
        let alertController = UIAlertController(title: nil, message: massage, preferredStyle: .alert)
        // Default のaction
        let defaultAction:UIAlertAction =
                    UIAlertAction(title: "OK",
                          style: .default,
                          handler:{
                            (action:UIAlertAction!) -> Void in
                            // 処理
                            self.kitView?.GxMakerPlayerOne.image = self.nogxmaker
                            self.kitView?.GxMakerPlayerTwo.image = self.nogxmaker
                            self.playerOneTableView.tableViewModel.resetGame()
                            self.playerTwoTableView.tableViewModel.resetGame()
                            self.playerOneTableView.tableView.reloadData()
                            self.playerTwoTableView.tableView.reloadData()
                            alertController.dismiss(animated: true, completion: nil)
                })
        let cancelAction:UIAlertAction =
                    UIAlertAction(title: "キャンセル",
                                  style: UIAlertAction.Style.cancel,
                          handler:{
                            (action:UIAlertAction!) -> Void in
                            // 処理
                            alertController.dismiss(animated: true, completion: nil)
                })
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }
}
