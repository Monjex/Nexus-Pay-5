//
//  SignUpVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 17/01/23.
//

import UIKit
import IBAnimatable

class SignUpVC: UIViewController {
    
    
    @IBOutlet weak var registerBtn: AnimatableButton!
    @IBOutlet weak var registerTitleLbl: UILabel!
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var alreadyAccBtn: UIButton!
    @IBOutlet weak var femalBtn: UIButton!
    
    @IBOutlet weak var passwordTxtFld: AnimatableTextField!
    @IBOutlet weak var dobTxtFld: AnimatableTextField!
    @IBOutlet weak var phoneNumberTxtFld: AnimatableTextField!
    
    @IBOutlet weak var confirmPasswordTxtFld: AnimatableTextField!
    @IBOutlet weak var emailTxtFld: AnimatableTextField!
    @IBOutlet weak var firstNameTxtFld: AnimatableTextField!
    
    @IBOutlet weak var lastNameTxtFld: AnimatableTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func registerAction(_ sender: Any) {
        
        

    }
    

}
