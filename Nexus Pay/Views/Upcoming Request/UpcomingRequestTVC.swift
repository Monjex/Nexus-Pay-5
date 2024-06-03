//
//  UpcomingRequestTVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 13/04/23.
//

import UIKit

class UpcomingRequestTVC: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var leaveTypeLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var eyeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "UpcomingRequestTVC", bundle: .main)
    }
    
    func setUI(leaveBalance : leaveSummaryList){
        
        let leaveStatus = leaveBalance.LeaveStatus ?? ""
        
        if leaveStatus == "Pending"{
            statusBtn.setTitleColor(UIColor.pending, for: .normal)
        }
        else if leaveStatus == "Approved"{
            statusBtn.setTitleColor(UIColor.approved, for: .normal)
        }
        else if leaveStatus == "Withdrawn"{
            statusBtn.setTitleColor(UIColor.withdrown, for: .normal)
        }
        else if leaveStatus == "Disapproved"{
            statusBtn.setTitleColor(UIColor.disapproved, for: .normal)
        }
        else if leaveStatus == "Cancelled"{
            statusBtn.setTitleColor(UIColor.cancelled, for: .normal)
        }
        else if leaveStatus == "Rejected"{
            statusBtn.setTitleColor(UIColor.rejectedColor, for: .normal)
        }
        
        leaveTypeLbl.text = leaveBalance.LeaveType ?? ""
        dateLbl.text = leaveBalance.LeaveDay ?? ""
        statusBtn.setTitle(leaveBalance.LeaveStatus, for: .normal)
        
        print(leaveBalance.Guid!)
        
    }
    
}
