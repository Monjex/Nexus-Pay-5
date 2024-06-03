//
//  PreviousRequestDetailVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 17/04/23.
//

import UIKit
import IBAnimatable
import FirebaseAnalytics
import SwiftGifOrigin
import Foundation

protocol boolValue: AnyObject {
    func boolValueChange(info: String)
}

protocol NotificationDecreaseDelegate: AnyObject {
    func BacktoNotification(info: String)
}


class PreviousRequestDetailVC: UIViewController {
    
    @IBOutlet var leaveDetailsView: UIView!
    @IBOutlet var statusView: AnimatableView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnsView: UIView!
    @IBOutlet weak var toSessionLbl: UILabel!
    @IBOutlet weak var pendingWithLbl: UILabel!
    @IBOutlet weak var pendingWithTitleLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusTitleLbl: UILabel!
    @IBOutlet weak var numberOfDaysLbl: UILabel!
    @IBOutlet weak var numberOfDaysTitleLbl: UILabel!
    @IBOutlet weak var toSessionTitleLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var toDateTitleLbl: UILabel!
    @IBOutlet weak var fromDateTitleLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var typeTitleLbl: UILabel!
    @IBOutlet weak var fromSessionLbl: UILabel!
    @IBOutlet weak var fromSessionTitleLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var appliedOnTitleLbl: UILabel!
    @IBOutlet weak var appliedOnLbl: UILabel!
    
    @IBOutlet weak var okBtn: AnimatableButton!
    @IBOutlet weak var withdrawBtn: AnimatableButton!
    
    @IBOutlet var reasonTxtView: UITextView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet var reasonView: AnimatableView!
    
    weak var delegate: boolValue? = nil
    
    weak var delegate2: NotificationDecreaseDelegate? = nil
    
    var guid = String()
    var status = String()
    
    var loader = Loader()
    
    var summarydetail : LeaveDetails?
    
    var notificationguid = String()
    
    var statusCode = Int()
    
    var fromRefresh = String()
    
    var sendingStatus = String()
    var sendingReason = String()
        
    var gifImageView: UIImageView! //gifOutlet
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        shadowView.isHidden = true
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBackFromDetail(_:)))
        swipeRight.edges = .left
        view.addGestureRecognizer(swipeRight)
        
        leaveSummaryDetailCall(guid: guid, notiguid: notificationguid, group: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: PreviousRequestDetailVC.self,
            AnalyticsParameterScreenClass: PreviousRequestDetailVC.self])
    }
    
    @objc func handleSwipeBackFromDetail(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.delegate?.boolValueChange(info: "backfromDetail")
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showGif() {
            // Create an instance of UIImageView with a GIF
        
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = false
        
            guard let gifURL = Bundle.main.url(forResource: "LeaveDetails-new1", withExtension: "gif"),
                  let imageData = try? Data(contentsOf: gifURL),
                  let gif = UIImage.gif(data: imageData) else {
                return
            }
        
        gifImageView = UIImageView(image: gif)
        
        

                // Disable autoresizing mask so that constraints can be applied
                gifImageView.translatesAutoresizingMaskIntoConstraints = false

                // Add the UIImageView to your view
                view.addSubview(gifImageView)

                // Set the frame to be fullscreen
                gifImageView.contentMode = .scaleToFill // or .scaleAspectFill depending on your preference

                // Set constraints
                NSLayoutConstraint.activate([
                    gifImageView.topAnchor.constraint(equalTo: leaveDetailsView.bottomAnchor), // Adjust the constant as needed
                    gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                    //gifImageView.heightAnchor.constraint(equalToConstant: 1500)
                ])
        }
    
    func hideGif() {
        // Hide the UIImageView or remove it from the superview
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = true
        gifImageView.removeFromSuperview()
        // Additional cleanup or actions can be performed here
    }
    
    
    func extractDateAndTimeAndConvertToLocal(from dateString: String) -> (String?, String?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        //yyyy-MM-dd'T'HH:mm:ss.SSSSS
        
        // Parse the input string
        if let date = dateFormatter.date(from: dateString) {
            // Adjust to local time zone
            let localDate = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
            
            // Format the date component
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let localDateString = dateFormat.string(from: localDate)
            
            // Format the time component
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let localTime = timeFormatter.string(from: localDate)
            
            return (localDateString, localTime)
        } else {
            return (nil, nil) // Unable to parse the date string
        }
    }
    
    func extractDateAndTimeAndConvertToLocal24(from dateString: String) -> (String?, String?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        //yyyy-MM-dd'T'HH:mm:ss.SSSSS
        
        // Parse the input string
        if let date = dateFormatter.date(from: dateString) {
            // Adjust to local time zone
            let localDate = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
            
            // Format the date component
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy"
            let localDateString = dateFormat.string(from: localDate)
            
            // Format the time component
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let localTime = timeFormatter.string(from: localDate)
            
            return (localDateString, localTime)
        } else {
            return (nil, nil) // Unable to parse the date string
        }
    }
    
    
    func SetDetailData(detail: LeaveDetails){
        
      //  let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
       // let newToDate = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
        
        let fromnew = detail.FromDate?.convertdateStringtoNewFormat(currentFormat: "dd MMM yyyy", toFormat: "dd/MM/yyyy")
        let tonew = detail.ToDate?.convertdateStringtoNewFormat(currentFormat: "dd MMM yyyy", toFormat: "dd/MM/yyyy")
        
    
        let locale = NSLocale.current
        let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        if formatter.contains("a") {
                //phone is set to 12 hours
            let dateString = detail.AppliedOn ?? ""

            let (localDate, localTime) = extractDateAndTimeAndConvertToLocal(from: dateString)
            if let localDate = localDate, let localTime = localTime {
                print("Local Date: \(localDate)")
                print("Local Time: \(localTime)")
                    
                appliedOnLbl.text = "\(localDate) \(localTime)"
                   
                let localDateString = appliedOnLbl.text!.UTCToLocal()
                print(localDateString)
                    
            } else {
                    print("Error parsing date string")
            }
            
            
        } else {
                //phone is set to 24 hours
            
            let dateString = detail.AppliedOn ?? ""
            
            var trimmedString1 = ""
            
            if let range = dateString.range(of: " AM") {
                let trimmedString = dateString.substring(to: range.lowerBound)
                print(trimmedString)
                trimmedString1 =  trimmedString
            } else if let range = dateString.range(of: " PM") {
                let trimmedString = dateString.substring(to: range.lowerBound)
                print(trimmedString)
                trimmedString1 =  trimmedString
            }
                else  {
                print("IST not found in the string")
            }
            
            

            let (localDate, localTime) = extractDateAndTimeAndConvertToLocal24(from: trimmedString1)
            if let localDate = localDate, let localTime = localTime {
                print("Local Date: \(localDate)")
                print("Local Time: \(localTime)")
                
                var localTime24 = ""
                
                let components = localTime.split(separator: ":")
                if let hourString = components.first,
                    let hour = Int(hourString) {
                    if hour > 11 {
                        print("Local Time: \(localTime) PM")
                        localTime24 = "\(localTime) PM"
                        
                    } else {
                        print("Local Time: \(localTime) AM")
                        localTime24 = "\(localTime) AM"
                    }
                } else {
                    print("Invalid time format")
                }
                
                appliedOnLbl.text = "\(localDate) \(localTime)"
              
                    
            } else {
                    print("Error parsing date string")
            }
            
        }
        
       
        typeLbl.text = detail.LeaveType ?? ""
        categoryLbl.text = detail.LeaveCategory ?? ""
        fromDateLbl.text = "\(fromnew!) - \(tonew!)"
        fromSessionLbl.text = "\(detail.FromSession!) - \(detail.ToSession!)"
        //toDateLbl.text = tonew
        //toSessionLbl.text = detail.ToSession ?? ""
        numberOfDaysLbl.text = "\(detail.NoOfDays ?? 0.0)"
        statusLbl.text = detail.RequestStatus ?? ""
        
        if detail.Reason == ""{
            
            reasonTxtView.text = "No Reason"
            
        }else{
            reasonTxtView.text = detail.Reason ?? ""
        }
                
        let requestsstatus = detail.RequestStatus ?? ""
        
        let leavecat = detail.LeaveCategory ?? ""
        
        self.status = requestsstatus
        
        if requestsstatus == "Withdrawn"{
            
            btnsView.isHidden = true
            bottomViewHeight.constant = 160
            pendingWithTitleLbl.text = "Withdrawn By"
            pendingWithLbl.text = detail.ApproverName ?? ""
           
        }
        else if leavecat == "Leave Cancel" && requestsstatus == "Approved"{
            btnsView.isHidden = true
            bottomViewHeight.constant = 160
            pendingWithTitleLbl.text = "Approved By"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        else if leavecat == "Leave Cancel" && requestsstatus == "Rejected"{
            btnsView.isHidden = true
            bottomViewHeight.constant = 160
            pendingWithTitleLbl.text = "Rejected By"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        
        else if requestsstatus == "Pending"{
            
            okBtn.isHidden = true
            withdrawBtn.setTitle("Withdraw", for: .normal)
            pendingWithTitleLbl.text = "Pending With"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        
        else if requestsstatus == "Approved"{
            
            okBtn.isHidden = true
            withdrawBtn.setTitle("Cancel Request", for: .normal)
            pendingWithTitleLbl.text = "Approved By"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        
        else if requestsstatus == "Disapproved"{
            
            btnsView.isHidden = true
            bottomViewHeight.constant = 160
            pendingWithTitleLbl.text = "Disapproved By"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        
        else if requestsstatus == "Cancelled"{
            
            btnsView.isHidden = true
            bottomViewHeight.constant = 160
            pendingWithTitleLbl.text = "Cancelled By"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        
        else if requestsstatus == "Rejected"{
            
            pendingWithLbl.text = detail.ApproverName ?? ""
            
            btnsView.isHidden = true
            bottomViewHeight.constant = 160
            pendingWithTitleLbl.text = "Rejected By"
        }
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        self.delegate?.boolValueChange(info: "backfromDetail")
        
        self.delegate2?.BacktoNotification(info: "WentToDetailsVC")
        
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: PreviousRequestDetailVC.self])
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func withdrawAction(_ sender: Any) {
        
        Analytics.logEvent("withdraw_action_ios", parameters: [AnalyticsParameterScreenName: PreviousRequestDetailVC.self])
        
        if status == "Approved"{
            shadowView.isHidden = false
            
            reasonView.frame.origin.y = view.frame.height

            // Show the reasonView with slide-up animation
            UIView.animate(withDuration: 0.4, animations: {
                // Slide reasonView up to the center of the screen
                self.reasonView.center.y = self.view.center.y
            })
            
        }
        else if status == "Pending"{
            shadowView.isHidden = true
            
            sendingStatus = "Withdrawn"
            sendingReason = ""
            
            changeLeaveStatusCall(guid: guid, status: sendingStatus, reason: sendingReason, group: nil)
        }
        
        
    }
    
    @IBAction func okAction(_ sender: Any) {
    }
    
    
    @IBAction func popupCancelAction(_ sender: Any) {
        Analytics.logEvent("popupCancel_action_ios", parameters: [AnalyticsParameterScreenName: PreviousRequestDetailVC.self])
        
        //shadowView.isHidden = true
        
        UIView.animate(withDuration: 0.4, animations: {
                // Slide reasonView back down below the screen
                self.reasonView.center.y = self.view.frame.height + self.reasonView.frame.height
            }) { (_) in
                // After animation completes, hide the shadowView
                self.shadowView.isHidden = true
            }
    }
    
    
    @IBAction func popupSubmitAction(_ sender: Any) {
        
        Analytics.logEvent("submit_action_ios", parameters: [AnalyticsParameterScreenName: PreviousRequestDetailVC.self])
        
        if validateSignUpDetails() {
            
            let reasonTxt = String(describing: reasonTxtView.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            
            sendingStatus = "Cancelled"
            sendingReason = reasonTxt
            
            changeLeaveStatusCall(guid: guid, status: sendingStatus, reason: sendingReason, group: nil)
        }
        
    }
    
    //================================
            //MARK: - Validation Fields
    //================================
            func validateSignUpDetails () -> Bool {

                if reasonTxtView.text?.trimmingCharacters(in: .whitespaces).count == 0 {

                    // Show Alert
                    self.showMessage("Please enter Reason")
                    //self.showMessage("Error", "Please enter Reason.")
                    reasonTxtView.resignFirstResponder()
                    return false

                }

                return true
            }
    
}

extension PreviousRequestDetailVC{
    
    
    func leaveSummaryDetailCall(guid: String, notiguid: String, group: DispatchGroup?){
       
        let viewModel = dashboardViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                  //  ActivityLoader.shared.showLoaderCentered()
                    //self!.showIndicator(withTitle: "Loading...")
                    self?.showGif()
                   // self!.loader.addLoader(view: self!.view)
                   // self!.loader.addLoaderBtn(btn: self!.loginBtn)
                } else {
                   // ActivityLoader.shared.hideLoader()
                    //self!.hideIndicator()
                    self?.hideGif()
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
                
                if self.statusCode == 401{
                    
                    self.fromRefresh = "Summary"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    self.summarydetail = viewModel.summaryDetails
                    
                    self.SetDetailData(detail: self.summarydetail!)
                }
                
        
            }

        }
        
        viewModel.guid = guid
        viewModel.notiId = notiguid
        viewModel.callGetLeaveSummaryDetailService = true
    }
    
    
    func changeLeaveStatusCall(guid: String, status: String, reason: String, group: DispatchGroup?){
       
        let viewModel = dashboardViewModel()

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
                
                let message = viewModel.responseMessage ?? ""

                self.showMessageForSomeTime(message, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.shadowView.isHidden = true
                       // self.navigationController?.popViewController(animated: true)
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainVC") as! HomeMainVC
                        self.navigationController?.pushViewController(secondViewController, animated: true)
                        
                    }
                })
                
                group?.leave()
                
        
            }

        }
        
        viewModel.guid = guid
        viewModel.status = status
        viewModel.reason = reason
        viewModel.callChangeLeaveStatusService = true
    }
    
    
    
    func refreshTokenCall(accesstoken: String, refreshtoken: String, group: DispatchGroup?){
       
        let viewModel = dashboardViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                  //  ActivityLoader.shared.showLoaderCentered()
                    //self!.showIndicator(withTitle: "Loading...")
                    self?.showGif()
                  
                } else {
                   
                    self?.hideGif()
                  
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

            DispatchQueue.main.async { [self] in
                
                group?.leave()
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 200{
                    
                    if self.fromRefresh == "Status"{
                        self.changeLeaveStatusCall(guid: self.guid, status: self.sendingStatus, reason: self.sendingReason, group: nil)
                    }
                    else{
                        self.leaveSummaryDetailCall(guid: self.guid, notiguid: self.notificationguid, group: nil)
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

extension String{

    func UTCToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: self) ?? Date()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm a"

        return dateFormatter.string(from: dt)
    }

}
