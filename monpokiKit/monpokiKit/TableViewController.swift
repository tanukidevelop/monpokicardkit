//
//  TableViewController.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/06/02.
//

import UIKit
import RxCocoa
import RxSwift


class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let disposeBag = DisposeBag()
    var tableViewModel = TableViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTableView()
    }
    
    func loadTableView() {
        self.tableView.tableFooterView = UIView()

        tableView.isScrollEnabled = false
        UITableView.appearance().separatorInset = UIEdgeInsets.zero
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "PokimonStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.allowableMovement = 10
        tableView.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        guard longPressGesture.state == .began else {
            return
        }
        
        let point = longPressGesture.location(in: self.tableView)
        guard let indexPath = self.tableView.indexPathForRow(at: point) else {
            return
        }
        print("CellLongTapped, index=\(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 移動用の処理を行う
        
        // 3:引数が1個の場合
        func changePokimon (index: Int){
            let beforeIndexPath = indexPath.section + indexPath.row
            let beforeMovingStatus = self.tableViewModel.statusList[beforeIndexPath] //0
            let DestinationStatus = self.tableViewModel.statusList[index]
            self.tableViewModel.statusList.remove(at: index)
            self.tableViewModel.statusList.insert(beforeMovingStatus.copy(), at: index)
            self.tableViewModel.statusList.remove(at: beforeIndexPath)
            self.tableViewModel.statusList.insert(DestinationStatus.copy(), at: beforeIndexPath)
            self.tableView.reloadData()
        }
        
        let showPopoverCell: PokimonStatusTableViewCell = tableView.cellForRow(at: indexPath) as! PokimonStatusTableViewCell
        let actionSheet = UIAlertController(title: "移動処理",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "バトル場へ移動", style: .default, handler: { (action:UIAlertAction) in
            changePokimon(index: 0)
        }))
        actionSheet.addAction(UIAlertAction(title: "ベンチ1へ移動", style: .default, handler: { (action:UIAlertAction) in
            changePokimon(index: 1)
        }))
        actionSheet.addAction(UIAlertAction(title: "ベンチ2へ移動", style: .default, handler: { (action:UIAlertAction) in
            changePokimon(index: 2)
        }))
        actionSheet.addAction(UIAlertAction(title: "ベンチ3へ移動", style: .default, handler: { (action:UIAlertAction) in
            changePokimon(index: 3)
        }))
        actionSheet.addAction(UIAlertAction(title: "ベンチ4へ移動", style: .default, handler: { (action:UIAlertAction) in
            changePokimon(index: 4)
        }))
        actionSheet.addAction(UIAlertAction(title: "ベンチ5へ移動", style: .default, handler: { (action:UIAlertAction) in
            changePokimon(index: 5)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "きぜつ（削除）", style: .destructive, handler: { (action:UIAlertAction) in
            var selectStatus = self.tableViewModel.statusList[(indexPath.section + indexPath.row)]
            self.tableViewModel.resetStatus(statsuModel: selectStatus)
            self.tableView.reloadData()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action:UIAlertAction) in
            self.tableViewModel.statusList.remove(at: (indexPath.section + indexPath.row))
            let newStatusModel = pokimonStatusModel()
            self.tableViewModel.statusList.insert(newStatusModel, at: (indexPath.section + indexPath.row))
        }))
        // iPad の場合のみ、ActionSheetを表示するための必要な設定
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController?.sourceView = showPopoverCell
            let screenSize = UIScreen.main.bounds
            actionSheet.popoverPresentationController?.sourceRect = showPopoverCell.frame
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showActionSheet(cell: PokimonStatusTableViewCell,isBattle: Bool, tableView: UITableView,indexPath:IndexPath) {
        cell.settingsButton.rx.tap.subscribe({ [weak self] _ in
            // ボタンタップでキックしたいアクションを記述
            let actionSheet = UIAlertController(title: "設定",
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            if (isBattle) {
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
            }
            
            actionSheet.addAction(UIAlertAction(title: "きぜつ（削除）", style: .destructive, handler: { (action:UIAlertAction) in
                var selectedStatus = self?.tableViewModel.statusList[(indexPath.section + indexPath.row)]
                self?.tableViewModel.resetStatus(statsuModel: selectedStatus!)
                tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? PokimonStatusTableViewCell {
            
            cell.status = tableViewModel.statusList[(indexPath.section + indexPath.row)]
            tableViewModel.loadCell(cell: cell, indexPath: indexPath, isOnePlayer: true)
            showActionSheet(cell: cell,isBattle: (indexPath.section == 0 && indexPath.row == 0),tableView: tableView,indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // 使用デバイスがiPadの場合
            return 80
        } else {
            // 使用デバイスがiPhoneの場合
            return 40
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedStatus: pokimonStatusModel
        selectedStatus = tableViewModel.statusList[(indexPath.section + indexPath.row)]
        selectedStatus.damage += 10
        tableView.reloadData()
    }
}

