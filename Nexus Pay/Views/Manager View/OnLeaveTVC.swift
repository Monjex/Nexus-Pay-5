//
//  OnLeaveTVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 09/06/23.
//

import UIKit

class OnLeaveTVC: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "OnLeaveTVC", bundle: .main)
    }
    
    func setUI(leaveBalance : managerSummaryList){
        nameLbl.text = leaveBalance.EmployeeName ?? ""
        typeLbl.text = leaveBalance.LeaveType ?? ""
    }
}
