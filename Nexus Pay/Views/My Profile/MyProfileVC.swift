//
//  MyProfileVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 17/04/23.
//

import UIKit
import SkyFloatingLabelTextField

class MyProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
