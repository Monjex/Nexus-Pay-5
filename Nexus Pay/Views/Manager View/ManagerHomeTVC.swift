//
//  ManagerHomeTVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 08/06/23.
//

import UIKit

class ManagerHomeTVC: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet var approveAllBtn: UIButton!
    @IBOutlet var leaveStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "ManagerHomeTVC", bundle: .main)
    }
    
    func setUI(managerSummary : managerSummaryList){
        
        let leavetype = managerSummary.LeaveType ?? ""
        let LeaveCategory = managerSummary.LeaveCategory ?? ""
        
        if leavetype == "CO" || leavetype == "Sal"{
            dateLbl.textColor = UIColor.overtimeRowColor
            nameLbl.textColor = UIColor.overtimeRowColor
            typeLbl.textColor = UIColor.overtimeRowColor
        }
        else if LeaveCategory == "Leave Cancel"{
            dateLbl.textColor = UIColor.red
            nameLbl.textColor = UIColor.red
            typeLbl.textColor = UIColor.red
        }
            
        else{
            dateLbl.textColor = UIColor.black
            nameLbl.textColor = UIColor.black
            typeLbl.textColor = UIColor.black
        }
        
//        if LeaveCategory == "Leave Cancel"{
//            dateLbl.textColor = UIColor.red
//            nameLbl.textColor = UIColor.red
//            typeLbl.textColor = UIColor.red
//        }
//        else{
//            dateLbl.textColor = UIColor.black
//            nameLbl.textColor = UIColor.black
//            typeLbl.textColor = UIColor.black
//        }
//
        dateLbl.text = managerSummary.LeaveDay ?? ""
        nameLbl.text = managerSummary.EmployeeName ?? ""
        typeLbl.text = managerSummary.LeaveType ?? ""
        
    }
    
}
