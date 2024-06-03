//
//  OtpVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 06/06/23.
//

import UIKit
import IBAnimatable
import FirebaseAnalytics

class OtpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var fourthOtpTxtFld: AnimatableTextField!
    @IBOutlet weak var thirdOtpTxtFld: AnimatableTextField!
    @IBOutlet weak var firstOtpTxtFld: AnimatableTextField!
    @IBOutlet weak var secondOtpTxtFld: AnimatableTextField!
    
    @IBOutlet weak var resendOtpBtn: UIButton!
    var loader = Loader()
    var email = String()
    
    var timer: Timer?
    var totalTime = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startOtpTimer()
        updateTimer()
        
        resendOtpBtn.setTitleColor(UIColor.lightGray, for: .normal)
        resendOtpBtn.isUserInteractionEnabled = false
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBack(_:)))
        swipeRight.edges = .left
        view.addGestureRecognizer(swipeRight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: OtpVC.self,
            AnalyticsParameterScreenClass: OtpVC.self])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    
    private func startOtpTimer() {
        self.totalTime = 120
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

            
    @objc func updateTimer() {
        print(self.totalTime)
        self.timerLbl.text = self.timeFormatted(self.totalTime) // will show timer
            if totalTime != 0 {
                totalTime -= 1  // decrease counter timer
                
            } else {
                resendOtpBtn.setTitleColor(UIColor.appOrange, for: .normal)
                resendOtpBtn.isUserInteractionEnabled = true
                
                if let timer = self.timer {
                    timer.invalidate()
                    self.timer = nil
                }
            }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%2d min : %02d sec", minutes, seconds)
    }
    
    // Text Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            if ((textField.text?.count)! < 1) && (string.count > 0) {

                if textField == firstOtpTxtFld{

                    secondOtpTxtFld.becomeFirstResponder()

                }

                if textField == secondOtpTxtFld{

                    thirdOtpTxtFld.becomeFirstResponder()

                }

                if textField == thirdOtpTxtFld{

                    fourthOtpTxtFld.becomeFirstResponder()

                }
                
                if textField == fourthOtpTxtFld{
                    fourthOtpTxtFld.resignFirstResponder()
                }

                textField.text = string

                return false

            }else if ((textField.text?.count)! >= 1) && (string.count == 0) {

                if textField == secondOtpTxtFld {

                    firstOtpTxtFld.becomeFirstResponder()

                }

                if textField == thirdOtpTxtFld {

                    secondOtpTxtFld.becomeFirstResponder()

                }

                if textField == fourthOtpTxtFld {

                    thirdOtpTxtFld.becomeFirstResponder()

                }

                if textField == firstOtpTxtFld {

                    firstOtpTxtFld.resignFirstResponder()

                }

                textField.text = ""

                return false

            }else if (textField.text?.count)! >= 1{

                textField.text = string

                return false

            }

            return true

        }
    
    
    @IBAction func backAction(_ sender: Any) {
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: ViewController.self])
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func resendOtpAction(_ sender: Any) {
        
        Analytics.logEvent("resend_action_ios", parameters: [AnalyticsParameterScreenName: ViewController.self])
        
        firstOtpTxtFld.text = ""
        secondOtpTxtFld.text = ""
        thirdOtpTxtFld.text = ""
        fourthOtpTxtFld.text = ""
        
        loginCall(group: nil)
    }
    
    
    
    @IBAction func verifyAction(_ sender: Any) {
        
        Analytics.logEvent("otpVerify_action_ios", parameters: [AnalyticsParameterScreenName: ViewController.self])
        
        if validateSignUpDetails() { // Check Validation

            firstOtpTxtFld.resignFirstResponder()
            secondOtpTxtFld.resignFirstResponder()
            thirdOtpTxtFld.resignFirstResponder()
            fourthOtpTxtFld.resignFirstResponder()

            let firstOtpTxt = String(describing: firstOtpTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let secondOtpTxt = String(describing: secondOtpTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let thirdOtpTxt = String(describing: thirdOtpTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let fourthOtpTxt = String(describing: fourthOtpTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let otpTxt = "\(firstOtpTxt)\(secondOtpTxt)\(thirdOtpTxt)\(fourthOtpTxt)"

            // Call Login Api
            otpCall(otp: otpTxt, group: nil)
 
        }
        
        
    }
    
    
    //================================
            //MARK: - Validation Fields
    //================================
            func validateSignUpDetails () -> Bool {
                
                if firstOtpTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0 && secondOtpTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0 && thirdOtpTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0 && fourthOtpTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                        
                    // Show Alert
                    self.showMessage("Kindly input the OTP.")
                    firstOtpTxtFld.resignFirstResponder()
                    secondOtpTxtFld.resignFirstResponder()
                    thirdOtpTxtFld.resignFirstResponder()
                    fourthOtpTxtFld.resignFirstResponder()
                    return false
                    
                }
                    
                else if firstOtpTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0{
                    
                    // Show Alert
                    self.showMessage("The OTP entered is invalid. Please try again.")
                    firstOtpTxtFld.resignFirstResponder()
                    return false
                }
                
                else if secondOtpTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0{
                    
                    // Show Alert
                    self.showMessage("The OTP entered is invalid. Please try again.")
                    secondOtpTxtFld.resignFirstResponder()
                    return false
                }
                
                else if thirdOtpTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0{
                    
                    // Show Alert
                    self.showMessage("The OTP entered is invalid. Please try again.")
                    thirdOtpTxtFld.resignFirstResponder()
                    return false
                }
                
                else if fourthOtpTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0{
                    
                    // Show Alert
                    self.showMessage("The OTP entered is invalid. Please try again.")
                    fourthOtpTxtFld.resignFirstResponder()
                    return false
                }
                    
                    
                return true
            }
    
}

extension OtpVC{
    
    func otpCall(otp:String, group: DispatchGroup?){
       
        let viewModel = UserViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                  //  ActivityLoader.shared.showLoaderCentered()
                    self!.showIndicator(withTitle: "Loading...")
                
                } else {
                   // ActivityLoader.shared.hideLoader()
                    self!.hideIndicator()
                   
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
                
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainVC") as! HomeMainVC
                self.navigationController?.pushViewController(secondViewController, animated: false)

                group?.leave()

            }

        }
        viewModel.otpString = otp
        viewModel.email = email
        viewModel.FirebaseDeviceToken = UserDefaultUtils.getDeviceToken(forkey: .deviceFcmToken)
        viewModel.callOtpService = true
    }
    
    func loginCall(group: DispatchGroup?){
       
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
                        
                        self.startOtpTimer()
                        self.updateTimer()
                        
                        self.resendOtpBtn.setTitleColor(UIColor.lightGray, for: .normal)
                        self.resendOtpBtn.isUserInteractionEnabled = false
                        
                    }
                })

                group?.leave()

            }

        }
        viewModel.email = email
        viewModel.callLoginService = true
    }
    
    
}
