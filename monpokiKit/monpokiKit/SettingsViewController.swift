//
//  SettingsViewController.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/06/03.
//

import UIKit

class SettingsViewController: UIViewController{
    var SettingModel = SettingsModel()
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "設定";
        loadTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func loadTableView() {
        self.tableView.tableFooterView = UIView()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case SettingMenu.ChangePlayMode.rawValue:
            cell.textLabel?.text = "データ切り替え人数"
        case SettingMenu.BuyAddBlock.rawValue:
            cell.textLabel?.text = "AppStoreで広告非表示機能（¥370）を購入する"
            cell.imageView?.image = UIImage(named: "moneyIcon.png")
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        if (AppStoreClass.shared.isPurchased) {
            return 1
        }
        return SettingMenu.count 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case SettingMenu.ChangePlayMode.rawValue:
        case SettingMenu.BuyAddBlock.rawValue:
            AppStoreClass.shared.buyAdBlockFromAppStore()
        default:
            break
        }
    }
}
