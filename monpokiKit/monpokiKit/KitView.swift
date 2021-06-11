//
//  KitView.swift
//  monpokiKit
//
//  Created by tanukidevelop on 2021/05/30.
//

import UIKit

class KitView: UIView {

    @IBOutlet weak var playerOneView: UIView!
    @IBOutlet weak var playerTwoView: UIView!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var cointossButton: UIButton!
    @IBOutlet weak var jankenButton: UIButton!
    
    @IBOutlet weak var playerOneUsedButton: UIButton!
    @IBOutlet weak var playerTwoUsedButton: UIButton!
    
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var stopTimerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
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
