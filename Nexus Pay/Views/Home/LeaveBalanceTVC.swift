//
//  LeaveBalanceTVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 06/06/23.
//

import UIKit
import IBAnimatable

class LeaveBalanceTVC: UITableViewCell {
    
    @IBOutlet weak var carryForwardHeight: NSLayoutConstraint!
    @IBOutlet weak var sideLineView: UIView!
    @IBOutlet weak var leaveLbl: UILabel!
    @IBOutlet weak var applyBtn: AnimatableButton!
    @IBOutlet weak var carryForwardLbl: UILabel!
    @IBOutlet weak var leaveNameLbl: UILabel!
    @IBOutlet weak var grantedAvailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "LeaveBalanceTVC", bundle: .main)
    }
    
    func setUI(leaveBalance : leaveBalanceList){
        
        let leaveType = leaveBalance.LeaveAbbreviation ?? ""
        
        if leaveType == "EL"{
            leaveNameLbl.textColor = UIColor.EL
            leaveLbl.textColor = UIColor.EL
            sideLineView.backgroundColor = UIColor.EL
        }
        else if leaveType == "CL"{
            leaveNameLbl.textColor = UIColor.CL
            leaveLbl.textColor = UIColor.CL
            sideLineView.backgroundColor = UIColor.CL
        }
        
        else if leaveType == "SL"{
            leaveNameLbl.textColor = UIColor.SL
            leaveLbl.textColor = UIColor.SL
            sideLineView.backgroundColor = UIColor.SL
        }
        
        else if leaveType == "CO"{
            leaveNameLbl.textColor = UIColor.comppOff
            leaveLbl.textColor = UIColor.comppOff
            sideLineView.backgroundColor = UIColor.comppOff
        }
        
        else if leaveType == "RH"{
            leaveNameLbl.textColor = UIColor.RH
            leaveLbl.textColor = UIColor.RH
            sideLineView.backgroundColor = UIColor.RH
        }
        
        if leaveType == "EL"{
            carryForwardLbl.isHidden = false
            carryForwardHeight.constant = 16
        }
        else{
            carryForwardLbl.isHidden = true
            carryForwardHeight.constant = 4
        }
         
        leaveNameLbl.text = "\(leaveBalance.LeaveType ?? "") (\(leaveBalance.LeaveAbbreviation ?? ""))"
        carryForwardLbl.text =  "Carry Forwarded (\(leaveBalance.CarryForwarded ?? 0))"
        
//        let granted = leaveBalance.Granted ?? 0.0
//
//        if granted == 0.0{
//
//        }
//        else{
//
//        }
        
        grantedAvailLbl.text = "Granted (\(leaveBalance.Granted ?? 0.0)) Availed (\(leaveBalance.Availed ?? 0.0))"
        leaveLbl.text = "\(leaveBalance.Balance ?? 0.0)"
    }
    
}
