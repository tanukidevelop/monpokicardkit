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
    
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var master: UIStackView!
    @IBOutlet weak var poisonLabel: UILabel!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var recoveryButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func tapRecoveryButton(_ sender: Any) {
        self.status?.damage -= 10
        self.damageLabel.text = String(self.status!.damage)

        if (self.status?.damage == 0) {
            damageLabel.isHidden = true
            poisonLabel.isHidden = true
            fireLabel.isHidden = true
            recoveryButton.isHidden = true
            settingsButton.isHidden = true
        }
    }
    
}
