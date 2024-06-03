//
//  HomeMainVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 17/01/23.
//

import UIKit

class HomeMainVC: CustomTabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if AuthUtils.getOfficeLocation() == "UK"{
            
            let index = [4]
            index.forEach{viewControllers?.remove(at: $0)}
            
        }
        
        self.delegate = self
        
    }
    
    // UITabBarControllerDelegate method
//       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//           print("Tab selected")
           
//           if let firstViewController = tabBarController.viewControllers?.first as? HomeVC {
//                       firstViewController.GetYearandMonth()
//           }
           
       //}
}

