//
//  SideMenuVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 18/01/23.
//

import UIKit
import IBAnimatable
import SideMenu

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var sideMenuTblView: UITableView!
    
    @IBOutlet weak var userImg: AnimatableImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    var menusArr = ["Home", "My Profile", "Upcoming Request", "Previous Request", "Company Holidays", "Leaves Balance", "Apply Leave", "Apply Overtime", "Logout"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sideMenuTblView.register(SideMenuTVC.loadNib(), forCellReuseIdentifier: "SideMenuTVC")
    }
    

}


extension SideMenuVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menusArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let Categoriescell : SideMenuTVC = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as! SideMenuTVC
        
        Categoriescell.menuLbl.text = menusArr[indexPath.row]
            
        return Categoriescell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 48
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: nil)
        if indexPath.row == 0{
            SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: nil)
        }
        if indexPath.row == 1{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
            self.navigationController?.pushViewController(secondViewController, animated: false)
        }
        if indexPath.row == 2{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "UpcomingRequestVC") as! UpcomingRequestVC
            self.navigationController?.pushViewController(secondViewController, animated: false)
        }
        if indexPath.row == 3{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PreviousRequestVC") as! PreviousRequestVC
            self.navigationController?.pushViewController(secondViewController, animated: false)
        }
        if indexPath.row == 4{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "CompanyHolidaysVC") as! CompanyHolidaysVC
            self.navigationController?.pushViewController(secondViewController, animated: false)
        }
        if indexPath.row == 5{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LeaveBalanceVC") as! LeaveBalanceVC
            self.navigationController?.pushViewController(secondViewController, animated: false)
        }
        if indexPath.row == 6{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ApplyRequestVC") as! ApplyRequestVC
            secondViewController.comeFrom = "Sidebar"
            self.navigationController?.pushViewController(secondViewController, animated: false)
        }
        if indexPath.row == 7{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ApplyOvertimeVC") as! ApplyOvertimeVC
            secondViewController.comeFrom = "Sidebar"
            self.navigationController?.pushViewController(secondViewController, animated: false)
        }
        if indexPath.row == 8{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                
               // SideMenuManager.default.leftMenuNavigationController?.dismiss(animated: true, completion: nil)
                
                self.showMessageCustom("Alert", "Are you sure you want to logout ?", options: ["Yes","No"], style: .alert) { (index) in
                    if index == 0 {
                        //self.LogoutApi()
                    }else{
                        print("no")
                    }
                }
            }
        }
        
        
    }
    
}
