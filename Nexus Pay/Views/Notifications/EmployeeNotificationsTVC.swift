//
//  EmployeeNotificationsTVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 05/07/23.
//

import UIKit

class EmployeeNotificationsTVC: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var senderNameLbl: UILabel!
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func loadNib() -> UINib? {
        UINib(nibName: "EmployeeNotificationsTVC", bundle: .main)
    }
    
    func setUI(notification : notificationsList){
        
        let newTime = notification.Time ?? ""

              //  print(newTime!)
            var fromnew = ""
        
            if (newTime.contains("ago")) || (newTime.contains("Ago")){
                fromnew = newTime

            }else{

                fromnew = (notification.Time?.convertdateStringtoNewFormat(currentFormat: "dd/MMM/yyyy", toFormat: "dd/MM/yyyy"))!

            }
        
        //fromnew = notification.Time?.convertdateStringtoNewFormat(currentFormat: "dd/MMM/yyyy", toFormat: "dd/MM/yyyy")
       // let tonew = detail.ToDate?.convertdateStringtoNewFormat(currentFormat: "dd MMM yyyy", toFormat: "dd/MM/yyyy")
        
        senderNameLbl.text = notification.Sender ?? ""
        notificationLbl.text = notification.Notification ?? ""
        timeLbl.text = fromnew
        
        let isView = notification.IsNotificationView ?? false
        
        if isView == false{
            mainView.backgroundColor = UIColor.notificationBackgroundColor
        }
        else{
            mainView.backgroundColor = UIColor.white
        }
    }
    
}
