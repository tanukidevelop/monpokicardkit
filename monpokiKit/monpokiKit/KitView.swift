//
//  KitView.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/05/30.
//

import UIKit

class KitView: UIView {

    @IBOutlet weak var playerOneTableView: UITableView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("KitView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

}
