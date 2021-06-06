//
//  TableViewModel.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/06/02.
//

import UIKit


class TableViewModel {
    
    var statusList: [pokimonStatusModel] = [
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel(),
        pokimonStatusModel()]
    
    init() {
        print("init")
    }
    
    func loadCell(cell: PokimonStatusTableViewCell, indexPath: IndexPath, isOnePlayer: Bool) {
        var cellStatus: pokimonStatusModel
        cellStatus = self.statusList[(indexPath.section + indexPath.row)]

        // ベンチは毒・やけどは回復する
        if (indexPath.section == 1) {
            cellStatus.poison = false
            cellStatus.fire = false
        }
        
        cell.settingsButton.isHidden = false
        cell.poisonImageView.isHidden = false
        cell.poisonLabel.isHidden = (cell.status?.poison == false)
        cell.fireLabel.isHidden = (cell.status?.fire == false)
        
        if (cellStatus.damage > 0) {
            cell.damageLabel?.text = String(cellStatus.damage)
            cell.damageLabel.isHidden = false
            cell.recoveryButton.isHidden = false
            cell.recoveryImageView.isHidden = false
        } else {
            cell.damageLabel.isHidden = true
            cell.recoveryButton.isHidden = true
            cell.recoveryImageView.isHidden = true
            
            // ベンチポケモンはダメージ0の場合は特殊状態アイコンを設定しない。
            if (indexPath.section == 1) {
                cell.settingsButton.isHidden = true
                cell.poisonImageView.isHidden = true
            }
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
    }
   
}

