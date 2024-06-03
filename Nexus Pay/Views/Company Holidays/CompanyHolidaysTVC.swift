//
//  CompanyHolidaysTVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 17/04/23.
//

import UIKit
import IBAnimatable

class CompanyHolidaysTVC: UITableViewCell {

    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var mainView: AnimatableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var holidayTypeLbl: UILabel!
    @IBOutlet weak var holidayNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "CompanyHolidaysTVC", bundle: .main)
    }
    
    func setUI(holiday : holidayList){
        
        dateLbl.text = holiday.Date ?? ""
        holidayNameLbl.text = holiday.Holiday ?? ""
        holidayTypeLbl.text = holiday.HolidayType ?? ""
        
        let holidatype = holiday.HolidayType ?? ""
        
        if holidatype == "Gazetted"{
            holidayTypeLbl.textColor = UIColor.orange
        }
        else{
            holidayTypeLbl.textColor = UIColor.approved
        }
        
        let isDisable = holiday.IsDisabled ?? false
        
        if isDisable == true || holidatype == "Gazetted"{
            typeBtn.isUserInteractionEnabled = false
            
            if holidatype == "Gazetted"{
                holidayTypeLbl.textColor = UIColor.orange
            }
            else{
                holidayTypeLbl.textColor = UIColor.lightGray
            }
        }
        else{
            typeBtn.isUserInteractionEnabled = true
        }
        
    }
    
}
