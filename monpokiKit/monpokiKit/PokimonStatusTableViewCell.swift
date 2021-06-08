//
//  PokimonStatusTableViewCell.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/05/30.
//

import UIKit

class PokimonStatusTableViewCell: UITableViewCell {
    
    var exist = false // ポキモンが存在しているかどうか
    var status: pokimonStatusModel?
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var master: UIStackView!
    @IBOutlet weak var poisonLabel: UILabel!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var recoveryImageView: UIImageView!
    @IBOutlet weak var recoveryButton: UIButton!
    @IBOutlet weak var poisonImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhoneの場合は「どく・やけど」ラベルのフォントを小さくする。
            self.poisonLabel!.font = UIFont.boldSystemFont(ofSize: 15.0)
            self.fireLabel!.font = UIFont.boldSystemFont(ofSize: 15.0)
        }


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func tappedRecoveryButton(_ sender: Any) {
        self.status?.damage -= 10
        self.damageLabel.text = String(self.status!.damage)
        
        if (self.status?.damage == 0) {
            self.status?.poison = false
            self.status?.fire = false
            self.damageLabel.isHidden = true
            self.poisonLabel.isHidden = true
            self.fireLabel.isHidden = true
            self.recoveryButton.isHidden = true
            self.settingsButton.isHidden = true
            self.recoveryImageView.isHidden = true
            self.poisonImageView.isHidden = true
        }

    }
}
