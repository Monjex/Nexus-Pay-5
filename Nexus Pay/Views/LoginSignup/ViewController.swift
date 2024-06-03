//
//  ViewController.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 17/01/23.
//

import UIKit
import IBAnimatable
import FirebaseAnalytics

class ViewController: UIViewController {
    
    var loader = Loader()
    
    @IBOutlet weak var loginBtn: AnimatableButton!
    @IBOutlet weak var emailTxtFld: AnimatableTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ConfigureWindow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: ViewController.self,
            AnalyticsParameterScreenClass: ViewController.self])
    }
    
    func ConfigureWindow(){
      
            if AuthUtils.getAuthToken() == "" || AuthUtils.getAuthToken() == nil{
                
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainVC") as! HomeMainVC
                self.navigationController?.pushViewController(vc, animated: false)
            }
   
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        Analytics.logEvent("login_action_ios", parameters: [AnalyticsParameterScreenName: ViewController.self])
        
        if validateSignUpDetails() { // Check Validation

            emailTxtFld.resignFirstResponder()

            let emailTxt = String(describing: emailTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))

            // Call Login Api
            loginCall(email: emailTxt,  group: nil)
 
        }
        
    }
    
    
    @IBAction func registerAction(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
         self.navigationController?.pushViewController(secondViewController, animated: false)
    }
    
    //================================
            //MARK: - Validation Fields
    //================================
            func validateSignUpDetails () -> Bool {
                
                if emailTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                        
                    // Show Alert
                    self.showMessage("Email address is required")
                    emailTxtFld.resignFirstResponder()
                    return false
                    
                }
                    
                else if emailTxtFld.text!.isValidEmail == false{
                    
                    // Show Alert
                    self.showMessage("Please provide a valid email address.")
                    emailTxtFld.resignFirstResponder()
                    return false
                }
                    
                    
                return true
            }
    

}


extension ViewController{
    
    func loginCall(email:String, group: DispatchGroup?){
       
        let viewModel = UserViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                  //  ActivityLoader.shared.showLoaderCentered()
                    self!.showIndicator(withTitle: "Loading...")
                   // self!.loader.addLoader(view: self!.view)
                   // self!.loader.addLoaderBtn(btn: self!.loginBtn)
                } else {
                   // ActivityLoader.shared.hideLoader()
                    self!.hideIndicator()
                   // self!.loader.removeLoader(view: self!.view)
                   // self!.loader.removeLoaderBtn(btn: self!.loginBtn)
                }}
            }
        }

        // For Alert message
        viewModel.showAlertClosure = { [weak self] () in
            guard let self = self else { return }
            group?.leave()
            DispatchQueue.main.async {
                if let message = viewModel.alertMessage {
                    self.showMessage("Error", message)
                }
                //completion(nil)
                //group.leave()
            }
        }

        // Response recieved
        viewModel.responseRecieved = { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                
                
                let message = viewModel.responseMessage ?? ""

                self.showMessageForSomeTime(message, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
                        secondViewController.email = self.emailTxtFld.text!
                        self.navigationController?.pushViewController(secondViewController, animated: true)
                    }
                })
               
                group?.leave()

            }

        }
        viewModel.email = email
        viewModel.callLoginService = true
    }
    
    
}

extension String {
  var isValidEmail: Bool {
       NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}

