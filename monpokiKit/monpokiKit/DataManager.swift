//
//  DataManager.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/06/11.
//

import Foundation

final class DataManager {
    var used1pSuppliqueGx = false
    var used1pGekkougaVunion = false
    var used1pMeutwoVunion = false
    var used1pZacianVunion = false
    
    var used2pSuppliqueGx = false
    var used2pGekkougaVunion = false
    var used2pMeutwoVunion = false
    var used2pZacianVunion = false

    private init() {}
    static let shared = DataManager()
    
    func resetUsed() {
        used1pSuppliqueGx = false
        used1pGekkougaVunion = false
        used1pMeutwoVunion = false
        used1pZacianVunion = false

        used2pSuppliqueGx = false
        used2pGekkougaVunion = false
        used2pMeutwoVunion = false
        used2pZacianVunion = false
    }
}
