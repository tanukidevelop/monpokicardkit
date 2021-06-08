//
//  DataManager.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/06/08.
//

import Foundation

final class DataManager {
    private init() {}
    static let shared = DataManager()
    
    public var inPlayerOneActiveMugenZone = false
    public var inPlayerTwoActiveMugenZone = false
}
