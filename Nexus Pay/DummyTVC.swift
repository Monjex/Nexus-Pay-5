//
//  DummyTVC.swift
//  Nexus Pay
//
//  Created by TGPL-MACMINI-66 on 04/06/24.
//

import UIKit

class DummyTVC: UITableViewCell {

    @IBOutlet var cellBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "DummyTVC", bundle: .main)
    }
    
}
