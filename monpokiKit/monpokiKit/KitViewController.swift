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
        
        // StoryboardでのTweetViewControllerの親ViewがTweetListViewなので取得できる。
        guard let kitView = view as? KitView else { return }
        self.kitView = kitView
        
        loadTableView()

        
        kitView.reloadButton.rx.tap.subscribe({ [weak self] _ in
            self?.kitView?.gx1pSwitch.setOn(false, animated: false)
            self?.kitView?.gx2pSwitch.setOn(false, animated: false)
            self?.playerOneTableView.tableViewModel.resetGame()
            self?.playerTwoTableView.tableViewModel.resetGame()
            self?.playerOneTableView.tableView.reloadData()
            self?.playerTwoTableView.tableView.reloadData()
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
        addTimer.invalidate()
        //timer処理
        addTimer = Timer.scheduledTimer(withTimeInterval: 180.0, repeats: true, block: { (timer) in
            self.requestShowAdMob()
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
