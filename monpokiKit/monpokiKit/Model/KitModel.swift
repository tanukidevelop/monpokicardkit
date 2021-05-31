//
//  KitModel.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/05/30.
//

import Foundation

struct pokimonStatusModel {
    var damage: Int = 0
    var poison: Bool = false
    var fire: Bool = false
}

class KitModel {
    init() {
    }
    
    func resetCell(cell: PokimonStatusTableViewCell){
        cell.status = pokimonStatusModel()
        cell.damageLabel.isHidden = true
        cell.poisonLabel.isHidden = true
        cell.fireLabel.isHidden = true
        cell.recoveryButton.isHidden = true
        cell.settingsButton.isHidden = true
        cell.recoveryImageView.isHidden = true
        cell.poisonImageView.isHidden = true
    }
    
    func addDamage(cell: PokimonStatusTableViewCell) {
        cell.status!.damage += 10
        cell.damageLabel.isHidden = false
        cell.recoveryButton.isHidden = false
        cell.recoveryImageView.isHidden = false
        cell.settingsButton.isHidden = false
        cell.poisonImageView.isHidden = false
        cell.damageLabel.text = String(cell.status!.damage)
    }
    
    func subDamage(cell: PokimonStatusTableViewCell) {
        cell.status!.damage -= 10
        if (cell.status!.damage == 0) {
            cell.damageLabel.isHidden = true
            cell.poisonLabel.isHidden = true
            cell.recoveryImageView.isHidden = true
            cell.fireLabel.isHidden = true
            cell.poisonImageView.isHidden = true

        }
    }
   
}
