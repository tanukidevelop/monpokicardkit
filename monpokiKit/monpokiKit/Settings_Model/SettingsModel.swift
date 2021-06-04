//
//  SettingsModel.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/06/03.
//

import UIKit

enum SettingMenu: Int {
    case ChangePlayMode = 0
    case RestoreAdBlock = 1
    case BuyAdBlock = 2
    
    case _count // ダミーカウンタ
    static let count = _count.rawValue // 利用するものはこちら
}


class SettingsModel {    
    let cellList = ["データ表示人数切り替え（1P ⇄ 1P + 2P）","「広告非表示機能」を復元","AppStoreで「広告非表示機能」を購入"]
}
