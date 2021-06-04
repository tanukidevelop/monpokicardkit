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
        
        if (AppStoreClass.shared.isPurchased) {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "データ切り替え人数"
            case 1:
                cell.textLabel?.text = "「広告非表示機能」を復元"
                cell.imageView?.image = UIImage(named: "moneyIcon.png")
            default:
                break
            }
        } else {
            switch indexPath.row {
            case SettingMenu.ChangePlayMode.rawValue:
                cell.textLabel?.text = "データ切り替え人数"
            case SettingMenu.RestoreAdBlock.rawValue:
                cell.textLabel?.text = "「広告非表示機能」を復元"
            case SettingMenu.BuyAdBlock.rawValue:
                cell.textLabel?.text = "「広告非表示機能」を購入"
                cell.imageView?.image = UIImage(named: "moneyIcon.png")
            default:
                break
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (AppStoreClass.shared.isPurchased) {
            return 2
        } else {
            return SettingMenu.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case SettingMenu.ChangePlayMode.rawValue: break
        case SettingMenu.RestoreAdBlock.rawValue:
            AppStoreClass.shared.restore()
        case SettingMenu.BuyAdBlock.rawValue:
            AppStoreClass.shared.buyAdBlockFromAppStore()
        default:
            break
        }
    }
}
