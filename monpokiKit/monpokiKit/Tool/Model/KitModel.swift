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
    
    func loadCell(cell: PokimonStatusTableViewCell, indexPath: IndexPath, isOnePlayer: Bool) {
        var cellStatus: pokimonStatusModel
        if (isOnePlayer) {
            cellStatus = self.statusList[(indexPath.section + indexPath.row)]
        } else {
            cellStatus = self.status2pList[(indexPath.section + indexPath.row)]
        }
        
        if (indexPath.section == 1) {
            cellStatus.poison = false
            cellStatus.fire = false
        }
        
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
    
    func resetStatus(statsuModel: pokimonStatusModel){
        statsuModel.damage = 0
        statsuModel.poison = false
        statsuModel.fire = false
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