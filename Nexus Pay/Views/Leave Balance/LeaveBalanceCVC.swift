//
//  LeaveBalanceCVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 18/04/23.
//

import UIKit
import IBAnimatable

class LeaveBalanceCVC: UICollectionViewCell {

    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var mainView: AnimatableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "LeaveBalanceCVC", bundle: .main)
    }
    
    
}
