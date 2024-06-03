//
//  UIViewController-Custom.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire

extension UIViewController {
    
    func showNoConnection(_ message: String = "The Internet connection appears to be offline.",completion: @escaping (Bool) -> ()) {
        let alertVC = UIAlertController(title: "Oops, something went wrong. Please try again.", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            completion(false)
        }))
        alertVC.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (alertAction) in
            completion(true)
        }))
        self.present(alertVC, animated: true)
    }
    
    func showMessageForSomeTime(_ message : String, completion:@escaping (()->Void)){
        let alertController = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        //alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alertController.view.tintColor = UIColor.black
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alertController.dismiss(animated: true, completion: nil)
            completion()
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alertController.view.tintColor = UIColor.black
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(_ message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: message, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        alertController.view.tintColor = UIColor.black
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alertController.view.tintColor = UIColor.black
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(_ title: String, _ message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        alertController.view.tintColor = UIColor.black
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMessageCustom(_ title: String, _ message: String, options:[String],style:UIAlertController.Style ,indexReturned:((Int)-> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for (index,option) in options.enumerated(){
            alertController.addAction(UIAlertAction(title: option, style: (index == options.count - 1) ? .cancel : .default, handler: { (action) in
                DispatchQueue.main.async {
                    indexReturned?(index)
                }
            }))
        }
        //alertController.view.tintColor = UIColor.black
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

extension UIViewController {
    
    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
   func showIndicator(withTitle title: String) {
      let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
      Indicator.label.text = title
      // Indicator.backgroundColor = .black
      // Indicator.alpha = 0.2
     // Indicator.isUserInteractionEnabled = false
      // Indicator.backgroundColor = UIColor.black.withAlphaComponent(0.3)
       Indicator.bezelView.color = .appBlue // Your backgroundcolor
       //Indicator.bezelView.style = .solidColor
       //Indicator.bezelView.tintColor = .white
       Indicator.bezelView.style = .solidColor
       //Indicator.tintColor = .appBlue
       Indicator.contentColor = .white
      //Indicator.detailsLabel.text = Description
       
      // var originalUserInteractionEnabled: Bool = true
              
        let window = UIApplication.shared.windows.first
      //  originalUserInteractionEnabled = window!.rootViewController?.view.isUserInteractionEnabled ?? true
        window!.rootViewController?.view.isUserInteractionEnabled = false
       
      Indicator.show(animated: true)
   }
   func hideIndicator() {
       
       let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = true
       
      MBProgressHUD.hide(for: self.view, animated: true)
   }
    
    
func Logout() {
        
// Show Loder
// loader.addLoader(view: self.view)
self.showIndicator(withTitle: "Loading...")

// ActivityLoader.shared.showLoaderCentered()

// Get AutorizationToken
// let AutorizationToken = UserDefaults.standard.string(forKey: "UserAuthorisationToken") ?? ""

let headers: HTTPHeaders = [
    "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
]

AF.request("\(APIConstants.Collective.authBaseURL)Login/LogOut", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
         //   print(response.value!)
            let json = response.value as? [String: Any]
            if json != nil{
                let json : NSDictionary = response.value as? NSDictionary ?? [:]
                print(json)
                let status = json.value(forKey: "StatusCode") as? Int ?? 0
                let message = json.value(forKey: "Message") as? String ?? ""
                if status == 200 {

                    // Hide Loader
                   // self.loader.removeLoader(view: self.view)
                    self.hideIndicator()
                    
                   // ActivityLoader.shared.hideLoader()
                    let userDefaults = UserDefaults.standard
                     
                        // Remove all keys except the one you want to keep
                        for (key, _) in userDefaults.dictionaryRepresentation() {
                            if key == "deviceFcmToken" {
                                // userDefaults.removeObject(forKey: key)
                                print("not removed")
                                                
                            }else{
                                userDefaults.removeObject(forKey: key)
                            }
                        }
                     
                        // Synchronize changes if needed
                        userDefaults.synchronize()
                   
                   // UserDefaultUtils.clearUserDefaults()
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(vc, animated: false)

                    
                }
                else if status == 401{
                    
                    // Hide Loader
                    self.hideIndicator()
                }
                else{
                    // Hide Loader
                    self.hideIndicator()
                    
                   // ActivityLoader.shared.hideLoader()
                  //  self.loader.removeLoader(view: self.view)
               // self.showAlert(msg: message)
                }
            }
            else {
                // Hide Loader
                //self.loader.removeLoader(view: self.view)
                self.hideIndicator()
              //  ActivityLoader.shared.hideLoader()
    
            }
            
        }
    }
    
}

extension UIViewController {
 
    @objc func handleSwipeBack(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            navigationController?.popViewController(animated: true)
        }
    }
    
}
    
