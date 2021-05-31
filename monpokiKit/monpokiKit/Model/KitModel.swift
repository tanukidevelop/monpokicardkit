//
//  KitModel.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/05/30.
//

import Foundation

class pokimonStatusModel {
    var damage: Int = 0
    var poison: Bool = false
    var fire: Bool = false
    
    func copy() -> pokimonStatusModel {
        let copyStatusModel = pokimonStatusModel()
        copyStatusModel.damage = self.damage
        copyStatusModel.poison = self.poison
        copyStatusModel.fire = self.fire
        return copyStatusModel
    }
}

class KitModel {
    
    var statusList = [
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel()]
    
    var status2pList = [
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel()]
    
    init() {
    }
    
    func loadCell(cell: PokimonStatusTableViewCell, indexPath: IndexPath ) {
        var cellStatus = self.statusList[(indexPath.section + indexPath.row)]
        
        if (cellStatus.damage > 0) {
            cell.damageLabel?.text = String(cellStatus.damage)

            cell.damageLabel.isHidden = false
            cell.poisonLabel.isHidden = !(cell.status?.poison == true)
            cell.fireLabel.isHidden = !((cell.status?.fire == true))
            
            if (indexPath.section == 1) {
                // ベンチは異常状態にならない
                cell.poisonLabel.isHidden = true
                cell.fireLabel.isHidden = true
            }
            cell.recoveryButton.isHidden = false
            cell.settingsButton.isHidden = false
            cell.recoveryImageView.isHidden = false
            cell.poisonImageView.isHidden = false
            
        } else {
            // ダメージ
            cell.damageLabel.isHidden = true
            cell.poisonLabel.isHidden = true
            cell.fireLabel.isHidden = true
            cell.recoveryButton.isHidden = true
            cell.settingsButton.isHidden = true
            cell.recoveryImageView.isHidden = true
            cell.poisonImageView.isHidden = true
        }
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
    
    func addDamage(indexPath: IndexPath) {
        var selectedStatus = self.statusList[(indexPath.section + indexPath.row)]
        selectedStatus.damage += 10
    }
    
    @objc func subDamage(indexPath: IndexPath)  {
        var selectedStatus = self.statusList[(indexPath.section + indexPath.row)]
        selectedStatus.damage -= 10

    }
    
    func resetGame() {
        statusList = [
            pokimonStatusModel(),
            pokimonStatusModel(),
            pokimonStatusModel(),
            pokimonStatusModel(),
            pokimonStatusModel(),
            pokimonStatusModel()]
        
        status2pList = [
            pokimonStatusModel(),
            pokimonStatusModel(),
            pokimonStatusModel(),
            pokimonStatusModel(),
            pokimonStatusModel(),
            pokimonStatusModel()]
    }
   
}
