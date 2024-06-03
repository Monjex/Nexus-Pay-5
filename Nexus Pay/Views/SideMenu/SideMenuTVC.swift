//
//  SideMenuTVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 18/01/23.
//

import UIKit

class SideMenuTVC: UITableViewCell {

    @IBOutlet weak var menuLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "SideMenuTVC", bundle: .main)
    }
    
}
