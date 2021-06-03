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
    }
    
    
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError("Empty Cell")
        }
        cell.textLabel?.text = SettingModel.cellList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingModel.cellList.count
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
