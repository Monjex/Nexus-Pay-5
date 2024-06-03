//
//  RHApplyVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/06/23.
//

import UIKit
import IBAnimatable
import Alamofire
import FirebaseAnalytics
import AVFoundation

protocol backToHoliday {
    func BackHoliday(holiday: String)
}

class RHApplyVC: UIViewController {
    
    var delegate: backToHoliday?
    
    @IBOutlet weak var applyingToLbl: UILabel!
    
    @IBOutlet weak var applyingDateLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var rhDateLbl: UILabel!
    @IBOutlet weak var rhTypeLbl: UILabel!
    @IBOutlet weak var ccLbl: UILabel!
    @IBOutlet weak var reasonTxtView: AnimatableTextView!
    
    var loader = Loader()
    
    var rhListArr = NSArray()
    
    var rhListMutableArr = NSMutableArray()
    
    var ccArr = NSArray()
    var ccMutableArr = NSMutableArray()
    
    var applyingTo = String()
    var applyingDate = String()
    var manageremail = String()
    
    var ccmanageremail = String()
    
    var fromDate = String()
    
    var holidayList : holidayList?
    
    var comefrom = String()
    
    var statusCode = Int()
    
    var fromRefresh = String()
    
    var rhFinalName = String()
    
    //audio code
    var audioPlayer: AVAudioPlayer?
    var retainSelf: RHApplyVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      //  print(manageremail)
       // print(applyingTo)
        
       retainSelf = self
        
        print(fromDate)
        
        reasonTxtView.clipsToBounds = true
        reasonTxtView.layer.shadowOpacity = 0.3
        reasonTxtView.layer.shadowOffset = CGSizeMake(3, 3)
        reasonTxtView.layer.shadowColor = UIColor.lightGray.cgColor
        
       // print(holidayList)
        
        if comefrom == "Holiday"{
            applyingToLbl.text = applyingTo
            
            applyingDateLbl.text = Date.getCurrentDateChangeNew()
        }
        else{
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                ActivityLoader.shared.showLoaderCentered()
//             }
//
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//                ActivityLoader.shared.hideLoader()
//             }
            
            
            applyingToLbl.text = applyingTo
            
            applyingDateLbl.text = Date.getCurrentDateChangeNew()
        }
        
        getDropdownData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: RHApplyVC.self,
            AnalyticsParameterScreenClass: RHApplyVC.self])
    }
    
    
    @IBAction func crossAction(_ sender: Any) {
        
        Analytics.logEvent("cross_action_ios", parameters: [AnalyticsParameterScreenName: RHApplyVC.self])
        
        if comefrom == "Holiday"{
            self.dismiss(animated: true)
            self.delegate?.BackHoliday(holiday: "")
            
        }
        else{
            self.dismiss(animated: true)
        }
        
       
    }
    
    
    @IBAction func rhTypeAction(_ sender: Any) {
        
        rhListMutableArr.removeAllObjects()
        
        for index in 0...self.rhListArr.count-1 {
            
            let dict = rhListArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Holiday") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.rhListMutableArr.add(String(title))
        }

        RPicker.selectOption(dataArray: (rhListMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.rhListArr[atIndex] as? NSDictionary ?? [:]
            
            let date = dict.value(forKeyPath: "Date") as? String ?? ""
            let balance = dict.value(forKeyPath: "Balance") as? Int ?? 0
            
            self!.rhTypeLbl.text = dict.value(forKeyPath: "Holiday") as? String ?? ""
            self!.rhDateLbl.text = date
            self!.balanceLbl.text = "Balance : \(balance)"
            self!.fromDate = dict.value(forKeyPath: "FromDate") as? String ?? ""
            
                
        }
        
    }
    
    
    @IBAction func ccAction(_ sender: Any) {
        
        ccMutableArr.removeAllObjects()
        
        for index in 0...self.ccArr.count-1 {
            
            let dict = ccArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.ccMutableArr.add(String(title))
        }

        RPicker.selectOption(dataArray: (ccMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.ccArr[atIndex] as? NSDictionary ?? [:]
            
            self!.ccLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
             
            self!.ccmanageremail = dict.value(forKeyPath: "Value") as? String ?? ""
            
                
        }
        
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        
        Analytics.logEvent("close_action_ios", parameters: [AnalyticsParameterScreenName: RHApplyVC.self])
        
        if comefrom == "Holiday"{
            self.dismiss(animated: true)
            self.delegate?.BackHoliday(holiday: "")
            
        }
        else{
            self.dismiss(animated: true)
        }
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        
        Analytics.logEvent("submit_action_ios", parameters: [AnalyticsParameterScreenName: RHApplyVC.self])
        
        let ramarks = reasonTxtView.text!
        let ccLbl = ccLbl.text!
        
        let dateString = self.fromDate
        
        if let indexOfT = dateString.firstIndex(of: "T") {
            let datePart = dateString.prefix(upTo: indexOfT)
            print(datePart)
            
            self.fromDate = String(datePart)
        } else {
            print("Invalid date string format")
        }
                        
        let dateFormatterTo = DateFormatter()
        dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
        let currentDateTo = Date()
        let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
        self.fromDate = "\(self.fromDate)\(formattedDateTo)"
                
        applyLeaveCall(type: "Restricted Holiday", startdate: self.fromDate, enddate: self.fromDate, sessionstart: "Session 1", sessionend: "Session 2", mobilenumber: "", applyto: self.applyingTo, manageremail: manageremail, remarks: ramarks, ccMnagerEmail: ccmanageremail, group: nil)
    }
    
}

extension RHApplyVC{
    
    
    func getDropdownData() {
        
        // Show Loder
       // loader.addLoader(view: self.view)
        self.showIndicator(withTitle: "Loading...")
      //  ActivityLoader.shared.showLoaderCentered()
        
        // Get AutorizationToken
        // let AutorizationToken = UserDefaults.standard.string(forKey: "UserAuthorisationToken") ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
        ]
        
        AF.request("\(APIConstants.Collective.authBaseURL)ApplyRequest/GetRestrictedHolidayList", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            //   print(response.value!)
            let json = response.value as? [String: Any]
            if json != nil{
                let json : NSDictionary = response.value as? NSDictionary ?? [:]
                print(json)
                let status = json.value(forKey: "StatusCode") as? Int ?? 0
                let message = json.value(forKey: "Message") as? String ?? ""
                if status == 200 {
                    
                    // Hide Loader
                  //  self.loader.removeLoader(view: self.view)
                    self.hideIndicator()
                  //  ActivityLoader.shared.hideLoader()
                    
                    self.rhListArr = json.value(forKey: "Data") as? NSArray ?? []
                    
                   // if self.comefrom == "Holiday"{
                        
                       // self.rhTypeLbl.text = self.holidayList?.Holiday ?? ""
                        
                        //self.balanceLbl.text = "Balance : \(self.holidayList?.Balance ?? 0)"
                        
                       // self.rhDateLbl.text = self.holidayList?.Date ?? ""
                        
                   // }
                  //  else{
                        
                        let holiday = self.rhListArr.value(forKey: "Holiday") as? NSArray ?? []
                        
                        let selected = self.rhListArr.value(forKey: "Selected") as? NSArray ?? []
                        
                        let Balance = self.rhListArr.value(forKey: "Balance") as? NSArray ?? []
                        
                        let Date = self.rhListArr.value(forKey: "Date") as? NSArray ?? []
                        
                        let fromdate = self.rhListArr.value(forKey: "FromDate") as? NSArray ?? []

                        if self.comefrom == "Holiday"{
                    
                            for index in 0..<holiday.count {

                                if let holiday = holiday[index] as? String,
                                   
                                    let selected = selected[index] as? Int,

                                    let Balance = Balance[index] as? Int,
                                   
                                    let Date = Date[index] as? String,
                                   
                                    let fromdate = fromdate[index] as? String,

                                    selected == 1 || selected == 0 {

                                    //new code
                                        if holiday == self.rhFinalName{
                                            self.rhTypeLbl.text = holiday
                                            self.balanceLbl.text = "Balance : \(Balance)"
                                            self.rhDateLbl.text = Date
                                            self.fromDate = fromdate

                                        }
                                    
                                }
                            
                            }
                            
                        }
                        else{
                            for index in 0..<holiday.count {

                                if let holiday = holiday[index] as? String,
                                   
                                    let selected = selected[index] as? Int,

                                    let Balance = Balance[index] as? Int,
                                   
                                    let Date = Date[index] as? String,
                                   
                                    let fromdate = fromdate[index] as? String,

                                    selected == 1 {

                                        self.rhTypeLbl.text = holiday
                                        self.balanceLbl.text = "Balance : \(Balance)"
                                        self.rhDateLbl.text = Date
                                        self.fromDate = fromdate
                                        
                                }
                            
                            }
                        }
                    
                }
                
                else if status == 401{
                    self.fromRefresh = "Filter"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    // Hide Loader
                  //  self.loader.removeLoader(view: self.view)
                    self.hideIndicator()
                    //self.showAlert(msg: message)
                   // ActivityLoader.shared.hideLoader()
                }
            }
            else {
                // Hide Loader
               // self.loader.removeLoader(view: self.view)
                self.hideIndicator()
               // ActivityLoader.shared.hideLoader()
                
            }
            
        }
    }
    
    
    
    func applyLeaveCall(type:String, startdate:String, enddate: String, sessionstart: String, sessionend: String, mobilenumber: String, applyto: String, manageremail: String, remarks: String, ccMnagerEmail: String, group: DispatchGroup?){
       
        let viewModel = ApplyRequestViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                  //  ActivityLoader.shared.showLoaderCentered()
                    self!.showIndicator(withTitle: "Loading...")
                    //self!.loader.addLoader(view: self!.view)
                   // self!.loader.addLoaderBtn(btn: self!.loginBtn)
                } else {
                  //  ActivityLoader.shared.hideLoader()
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
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 401{
                    
                    self.fromRefresh = "Apply"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    let message = viewModel.responseMessage ?? ""
                    
                    if let soundURL = Bundle.main.url(forResource: "success-1-6297", withExtension: "mp3") {
                                do {
                                    // Initialize the audio player
                                    self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                                    
                                    // Ensure the audio will play even when the view controller is popped
                                    self.audioPlayer?.delegate = self
                                    print(soundURL)
                                    // Play the sound
                                    self.audioPlayer?.play()
                                } catch {
                                    print("Error loading sound file: \(error.localizedDescription)")
                                }
                            } else {
                                print("Sound file not found")
                            }

                    self.showMessageForSomeTime(message, completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.dismiss(animated: true)
                            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainVC") as! HomeMainVC
                            self.navigationController?.pushViewController(secondViewController, animated: false)
                            
                        }
                    })
                }
                
                group?.leave()

            }

        }
        viewModel.leaveType = type
        viewModel.startDate = startdate
        viewModel.endDate = enddate
        viewModel.startSession = sessionstart
        viewModel.endSession = sessionend
        viewModel.mobileNumber = mobilenumber
        viewModel.applyingTo = applyto
        viewModel.managerEmail = manageremail
        viewModel.ccmanagerEmail = ccMnagerEmail
        viewModel.remarks = remarks
        viewModel.timezone = AuthUtils.getOfficeLocation()
        viewModel.callApplyLeaveService = true
    }
    
    
    func refreshTokenCall(accesstoken: String, refreshtoken: String, group: DispatchGroup?){
       
        let viewModel = ApplyRequestViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                  //  ActivityLoader.shared.showLoaderCentered()
                    self!.showIndicator(withTitle: "Loading...")
                    //self!.loader.addLoader(view: self!.view)
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
                
                group?.leave()
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 200{
                    
                    if self.fromRefresh == "Filter"{
                        self.getDropdownData()
                    }
                    else {
                        let ramarks = self.reasonTxtView.text!
                        let ccLbl = self.ccLbl.text!
                        
                        self.applyLeaveCall(type: "Restricted Holiday", startdate: self.fromDate, enddate: self.fromDate, sessionstart: "", sessionend: "", mobilenumber: "", applyto: self.applyingTo, manageremail: self.manageremail, remarks: ramarks, ccMnagerEmail: self.ccmanageremail, group: nil)
                    }
                    
                    
                }
                else{
                    
                    self.showMessageForSomeTime("Please login again.", completion: {
                        self.Logout()
//                        UserDefaultUtils.clearUserDefaults()
//
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                        self.navigationController?.pushViewController(vc, animated: false)
                    })
                    
                }
                
            }

        }
        viewModel.access_token = accesstoken
        viewModel.refresh_token = refreshtoken
        viewModel.callRefreshTokenService = true
    }
    

}

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MMM d, yyyy"

        return dateFormatter.string(from: Date())

    }
    
    static func getCurrentDateChange() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "YYYY-MM-dd"

           return dateFormatter.string(from: Date())

       }
    
    static func getCurrentDateChangeNew() -> String {

           let dateFormatter = DateFormatter()

           dateFormatter.dateFormat = "dd/MM/yyyy"

           return dateFormatter.string(from: Date())

       }
}

extension String {

    func convertdateStringtoNewFormat(currentFormat: String, toFormat : String) ->  String {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = currentFormat
        let resultDate = dateFormator.date(from: self)
        dateFormator.dateFormat = toFormat
        return dateFormator.string(from: resultDate!)
    }

}

extension RHApplyVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Release the audio player once it's done playing
        audioPlayer = nil
        
        retainSelf = nil
    }
}
