//
//  KitViewController.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/05/30.
//

import UIKit
import RxSwift
import RxCocoa


class KitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    var kitView : KitView?
    var kitModel = KitModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // StoryboardでのTweetViewControllerの親ViewがTweetListViewなので取得できる。
        guard let kitView = view as? KitView else { return }
        self.kitView = kitView
        loadTableView()
        
    }
    
    func loadTableView() {
        
        kitView?.playerOneTableView.isScrollEnabled = false
        UITableView.appearance().separatorInset = UIEdgeInsets.zero

        kitView?.playerOneTableView.delegate = self
        kitView?.playerOneTableView.dataSource = self
        
        kitView?.playerOneTableView.register(UINib(nibName: "PokimonStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
    func showActionSheet(cell: PokimonStatusTableViewCell) {
        cell.settingsButton.rx.tap.subscribe({ [weak self] _ in
            // ボタンタップでキックしたいアクションを記述
            let actionSheet = UIAlertController(title: "設定",
                                                message: nil,
                                                preferredStyle: .actionSheet)
         
            let showPoisonString = (cell.status?.poison == true) ? "「どく」解除" : "「どく」状態にする"
            let showFireString = (cell.status?.fire == true) ? "「やけど」解除" : "「やけど」状態にする"

            actionSheet.addAction(UIAlertAction(title: showPoisonString, style: .default, handler: { (action:UIAlertAction) in
                if (cell.status?.poison == true) {
                    cell.poisonLabel.isHidden = true
                    cell.status?.poison = false
                } else {
                    cell.poisonLabel.isHidden = false
                    cell.status?.poison = true
                }
            }))
            actionSheet.addAction(UIAlertAction(title: showFireString, style: .default, handler: { (action:UIAlertAction) in
                if (cell.status?.fire == true) {
                    cell.fireLabel.isHidden = true
                    cell.status?.fire = false
                } else {
                    cell.fireLabel.isHidden = false
                    cell.status?.fire = true
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "きぜつ（削除）", style: .default, handler: { (action:UIAlertAction) in
                self?.kitModel.resetCell(cell: cell)
            }))
            actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action:UIAlertAction) in
            }))
            // iPad の場合のみ、ActionSheetを表示するための必要な設定
            if UIDevice.current.userInterfaceIdiom == .pad {
                actionSheet.popoverPresentationController?.sourceView = cell
                let screenSize = UIScreen.main.bounds
                actionSheet.popoverPresentationController?.sourceRect = cell.frame
            }
         
            self?.present(actionSheet, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
         return 5
     }
     // Sectioのタイトル
     func tableView(_ tableView: UITableView,
                    titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return " バトルポケモン"
        case 1:
            return " ベンチポケモン"
        default:
            return ""
        }
     }
    
    // セクションの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? PokimonStatusTableViewCell {
            kitModel.resetCell(cell: cell)
            showActionSheet(cell: cell)
            return cell

        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PokimonStatusTableViewCell else { return }
        kitModel.addDamage(cell: cell)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
