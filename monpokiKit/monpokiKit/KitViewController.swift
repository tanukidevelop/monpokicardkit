//
//  KitViewController.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/05/30.
//

import UIKit
import RxSwift
import RxCocoa


class KitViewController: UIViewController {
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
        
        kitView.reloadButton.rx.tap.subscribe({ [weak self] _ in
            self?.kitView?.gx1pSwitch.setOn(false, animated: false)
            self?.kitView?.gx2pSwitch.setOn(false, animated: false)
            self?.playerOneTableView.tableViewModel.resetGame()
            self?.playerTwoTableView.tableViewModel.resetGame()
            self?.playerOneTableView.tableView.reloadData()
            self?.playerTwoTableView.tableView.reloadData()
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
        }).disposed(by: disposeBag)

        playerOneTableView.tableViewModel.resetGame()
        playerTwoTableView.tableViewModel.resetGame()
        
        self.kitView?.playerOneView.frame = playerOneTableView.view.frame
        self.kitView?.playerTwoView.frame = playerTwoTableView.view.frame

        self.kitView?.playerOneView?.addSubview(playerOneTableView.view!)
        self.kitView?.playerTwoView?.addSubview(playerTwoTableView.view!)
        
        print(self.kitView?.playerOneView?.frame)
        print(playerOneTableView.view.frame)


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

    
}
