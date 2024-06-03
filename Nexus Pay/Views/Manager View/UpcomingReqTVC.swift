//
//  UpcomingReqTVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 08/06/23.
//

import UIKit
import IBAnimatable

class UpcomingReqTVC: UITableViewCell {
    
    @IBOutlet weak var mainView: AnimatableView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "UpcomingReqTVC", bundle: .main)
    }
    
    func setUI(leaveBalance : managerSummaryList){
        
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
        
//        if leaveStatus == "Cancelled"{
//            nameLbl.textColor = UIColor.red
//            typeLbl.textColor = UIColor.red
//            dateLbl.textColor = UIColor.red
//        }
//        else{
//            nameLbl.textColor = UIColor.black
//            typeLbl.textColor = UIColor.black
//            dateLbl.textColor = UIColor.black
//        }
        
        nameLbl.text = leaveBalance.EmployeeName ?? ""
        typeLbl.text = leaveBalance.LeaveType ?? ""
        dateLbl.text = leaveBalance.LeaveDay ?? ""
        statusBtn.setTitle(leaveBalance.LeaveStatus, for: .normal)
        
        let leavecategory = leaveBalance.LeaveCategory ?? ""
        let leavetype = leaveBalance.LeaveType ?? ""
        
        if leavecategory == "Overtime" && leavetype == "CO"{
            dateLbl.textColor = UIColor.overtimeRowColor
            nameLbl.textColor = UIColor.overtimeRowColor
            typeLbl.textColor = UIColor.overtimeRowColor
        }
        else if leavecategory == "Overtime" && leavetype == "Sal"{
            dateLbl.textColor = UIColor.overtimeRowColor
            nameLbl.textColor = UIColor.overtimeRowColor
            typeLbl.textColor = UIColor.overtimeRowColor
        }
        else if (leavecategory == "Leave Cancel") && (leaveStatus == "Cancelled" || leaveStatus == "Rejected" || leaveStatus == "Approved"){
            nameLbl.textColor = UIColor.red
            typeLbl.textColor = UIColor.red
            dateLbl.textColor = UIColor.red
        }
        else{
            dateLbl.textColor = UIColor.black
            nameLbl.textColor = UIColor.black
            typeLbl.textColor = UIColor.black
        }
        
    }
    
}


