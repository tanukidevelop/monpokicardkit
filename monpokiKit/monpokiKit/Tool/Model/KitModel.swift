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
