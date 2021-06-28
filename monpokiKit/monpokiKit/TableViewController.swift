//
//  TableViewController.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/06/02.
//

import UIKit
import RxCocoa
import RxSwift


class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    let disposeBag = DisposeBag()
    var tableViewModel = TableViewModel()
    var isDamagePicker = true
    public var isActiveMugenzone = false // ムゲンゾーン表示（デフォルトはOFF）
    var damageList = [0,10,20,30,40,50,60,70,80,90,100,
                      110,120,130,140,150,160,170,180,190,200,
                      210,220,230,240,250,260,270,280,290,300,
                      310,320,330,340,350,360,370,380,390,400,
                      410,420,430,440,450,460,470,480,490,500]
    var selectDamage = 0
    
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
        
        if (self.isActiveMugenzone) {
            actionSheet.addAction(UIAlertAction(title: "ベンチ6へ移動", style: .default, handler: { (action:UIAlertAction) in
                changePokimon(index: 6)
            }))
            actionSheet.addAction(UIAlertAction(title: "ベンチ7へ移動", style: .default, handler: { (action:UIAlertAction) in
                changePokimon(index: 7)
            }))
            actionSheet.addAction(UIAlertAction(title: "ベンチ8へ移動", style: .default, handler: { (action:UIAlertAction) in
                changePokimon(index: 8)
            }))
        }
        
        if (indexPath.section == 0) {
            let showPoisonString = (showPopoverCell.status?.poison == true) ? "「どく」解除" : "「どく」状態にする"
            let showFireString = (showPopoverCell.status?.fire == true) ? "「やけど」解除" : "「やけど」状態にする"
            actionSheet.addAction(UIAlertAction(title: showPoisonString, style: .default, handler: { (action:UIAlertAction) in
                if (showPopoverCell.status?.poison == true) {
                    showPopoverCell.poisonLabel.isHidden = true
                    showPopoverCell.status?.poison = false
                } else {
                    showPopoverCell.poisonLabel.isHidden = false
                    showPopoverCell.status?.poison = true
                }
            }))
            actionSheet.addAction(UIAlertAction(title: showFireString, style: .default, handler: { (action:UIAlertAction) in

                if (showPopoverCell.status?.fire == true) {
                    showPopoverCell.fireLabel.isHidden = true
                    showPopoverCell.status?.fire = false
                } else {
                    showPopoverCell.fireLabel.isHidden = false
                    showPopoverCell.status?.fire = true
                }
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "USED:切り替え", style: .default, handler: { (action:UIAlertAction) in
            var selectStatus = self.tableViewModel.statusList[(indexPath.section + indexPath.row)]

            selectStatus.used = !(selectStatus.used)
            self.tableView.reloadData()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "きぜつ（削除）", style: .default, handler: { (action:UIAlertAction) in
            var selectStatus = self.tableViewModel.statusList[(indexPath.section + indexPath.row)]
            self.tableViewModel.resetStatus(statsuModel: selectStatus)
            self.tableView.reloadData()
        }))
        

        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .destructive, handler: { (action:UIAlertAction) in
        }))
        // iPad の場合のみ、ActionSheetを表示するための必要な設定
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController?.sourceView = showPopoverCell
            let screenSize = UIScreen.main.bounds
            actionSheet.popoverPresentationController?.sourceRect = showPopoverCell.frame
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? PokimonStatusTableViewCell {
            
            cell.status = tableViewModel.statusList[(indexPath.section + indexPath.row)]
            tableViewModel.loadCell(cell: cell, indexPath: indexPath, isOnePlayer: true)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // 使用デバイスがiPadの場合
            if (isActiveMugenzone) {
                // ムゲンゾーンが有効の時
                return 60
            } else {
                // 通常の時
                return 80
            }
        } else {
            // 使用デバイスがiPhoneの場合
            return 40
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
            if (isActiveMugenzone) {
                // ムゲンゾーンが有効な時
                return 8
            } else {
                // 通常時
                return 5
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isDamagePicker) {
            showDamagePickerView(selectIndexPath: indexPath)
        } else {
            var selectedStatus: pokimonStatusModel
            selectedStatus = tableViewModel.statusList[(indexPath.section + indexPath.row)]
            selectedStatus.damage += 10
            tableView.reloadData()
        }
        return

    }
    
    func showDamagePickerView(selectIndexPath: IndexPath)  {
        let alertView = UIAlertController(
            title: "ダメージを選択してください",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)

        let pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 270, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self

        // comment this line to use white color
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)

        alertView.view.addSubview(pickerView)

        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            var selectedStatus: pokimonStatusModel
            selectedStatus = self.tableViewModel.statusList[(selectIndexPath.section + selectIndexPath.row)]
            selectedStatus.damage += self.selectDamage
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)


        alertView.addAction(action)
        alertView.addAction(cancelAction)

        present(alertView, animated: true, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return damageList.count
    }
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return String(damageList[row])
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        print(damageList[row])
        selectDamage = damageList[row]
    }
    
    // ムゲンゾーン⇄通常モンスターを入れ替える
    public func changeActiveMugenzone() {
        isActiveMugenzone = !(isActiveMugenzone)
        self.tableView.reloadData()
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.tableView.isScrollEnabled = isActiveMugenzone
        }
    }
    
    // ムゲンゾーン⇄通常モンスターを入れ替える
    public func InActiveMugenzone() {
        isActiveMugenzone = false
        self.tableView.reloadData()
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.tableView.isScrollEnabled = false
        }
    }
}

