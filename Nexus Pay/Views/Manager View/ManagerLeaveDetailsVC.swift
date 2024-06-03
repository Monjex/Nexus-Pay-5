//
//  ManagerLeaveDetailsVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 08/06/23.
//

import UIKit
import IBAnimatable
import FirebaseAnalytics
import SwiftGifOrigin
import AVFoundation

protocol DataEnteredDelegate: AnyObject {
    func BackToPreviousReq(info: String)
}

protocol NotificationDecreaseDelegate1: AnyObject {
    func BacktoNotification1(info: String)
}

class ManagerLeaveDetailsVC: UIViewController {
    
    @IBOutlet var leaveDetailsView: UIView!
    @IBOutlet weak var bottomsViewHeight: NSLayoutConstraint!
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
    
    @IBOutlet var reasonTxtView: UITextView!
    @IBOutlet weak var okBtn: AnimatableButton!
    @IBOutlet weak var withdrawBtn: AnimatableButton!
    
    
    @IBOutlet var elMainLbl: UILabel!
    @IBOutlet var elCarryForwardLbl: UILabel!
    @IBOutlet var elGrantedLbl: UILabel!
    @IBOutlet var elBarView: UIView!
    
    @IBOutlet var clBarView: UIView!
    @IBOutlet var clGrantedLbl: UILabel!
    @IBOutlet var clMainLbl: UILabel!
    
    
    @IBOutlet var slMainLbl: UILabel!
    @IBOutlet var slBarView: UIView!
    @IBOutlet var slGrantedLbl: UILabel!
    
    
    @IBOutlet var coMainLbl: UILabel!
    @IBOutlet var coBarView: UIView!
    @IBOutlet var coGrantedLbl: UILabel!
    
    
    @IBOutlet var rhMainLbl: UILabel!
    @IBOutlet var rhBarView: UIView!
    @IBOutlet var rhGrantedLbl: UILabel!
    
    //  @IBOutlet weak var reasonTxtView: AnimatableTextView!
    
    weak var delegate: DataEnteredDelegate? = nil
    weak var delegate2: NotificationDecreaseDelegate1? = nil
    
    var notificationguid = String()
    
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet var reasonView: AnimatableView!
    
    var guid = String()
    var status = String()
    var leavecategory = String()
    
    var loader = Loader()
    
    var summarydetail : LeaveDetails?
    
    var statusCode = Int()
    
    var fromRefresh = String()
    
    var reasonTxtSend = String()
    var statusSend = String()
    
    var gifImageView: UIImageView! //gifOutlet
    
    //audio code
    var audioPlayer: AVAudioPlayer?
    var retainSelf: ManagerLeaveDetailsVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        shadowView.isHidden = true
        
        retainSelf = self
        
        //  print(status)
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBack1(_:)))
        swipeRight.edges = .left
        view.addGestureRecognizer(swipeRight)
        
        leaveSummaryDetailCall(guid: guid, notiguid: notificationguid, group: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: ManagerLeaveDetailsVC.self,
            AnalyticsParameterScreenClass: ManagerLeaveDetailsVC.self])
    }
    
    @objc func handleSwipeBack1(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.delegate2?.BacktoNotification1(info: "WentToDetailsVC")
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
                gifImageView.contentMode = .scaleAspectFit // or .scaleAspectFill depending on your preference

                // Set constraints
                NSLayoutConstraint.activate([
                    gifImageView.topAnchor.constraint(equalTo: leaveDetailsView.bottomAnchor), // Adjust the constant as needed
                    gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
       // pendingWithLbl.text = detail.ApproverName ?? ""
        
        if detail.Reason == ""{
            
            reasonTxtView.text = "No Reason"
            
        }else{
            reasonTxtView.text = detail.Reason ?? ""
        }
        
        let requeststatus = detail.RequestStatus ?? ""
        
        self.status = requeststatus
        
        let leavecategory = detail.LeaveCategory ?? ""
        
        if requeststatus == "Rejected"{
            pendingWithTitleLbl.text = "Rejected By"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        else if requeststatus == "Pending"{
            pendingWithTitleLbl.text = "Pending With"
           // pendingWithLbl.text = AuthUtils.getFirstName()
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        else if requeststatus == "Approved"{
            pendingWithTitleLbl.text = "Approved By"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        else if requeststatus == "Cancelled"{
            pendingWithTitleLbl.text = "Pending With"
            pendingWithLbl.text = AuthUtils.getFirstName()
        }
        else if requeststatus == "Withdrawn"{
            pendingWithTitleLbl.text = "Withdrawn By"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        else if requeststatus == "Disapproved"{
            pendingWithTitleLbl.text = "Disapproved By"
            pendingWithLbl.text = detail.ApproverName ?? ""
        }
        
        
        if (leavecategory == "Leave Cancel") && (requeststatus == "Approved" || requeststatus == "Rejected"){
        
            btnsView.isHidden = true
            bottomsViewHeight.constant = 450
            
        }
        
        else if (leavecategory == "Leave") && (requeststatus == "Approved" || requeststatus == "Rejected"){
        
            btnsView.isHidden = true
            bottomsViewHeight.constant = 450
            
        }
        
        else if (leavecategory == "Overtime") && (requeststatus == "Approved" || requeststatus == "Rejected"){
        
            btnsView.isHidden = true
            bottomsViewHeight.constant = 450
            
        }
        
        
        else if (leavecategory == "Restricted Holiday") && (requeststatus == "Approved" || requeststatus == "Rejected"){
        
            btnsView.isHidden = true
            bottomsViewHeight.constant = 450
            
        }
        
        else if requeststatus == "Withdrawn"{
            btnsView.isHidden = true
            bottomsViewHeight.constant = 450
        }
        else if requeststatus == "Disapproved"{
            btnsView.isHidden = true
            bottomsViewHeight.constant = 450
        }
        else{
            btnsView.isHidden = false
            bottomsViewHeight.constant = 540
            withdrawBtn.setTitle("Decline", for: .normal)
        }
        
        //Employee Leave Balance Code
        elMainLbl.textColor = UIColor.EL
        elBarView.backgroundColor = UIColor.EL
        
        clMainLbl.textColor = UIColor.CL
        clBarView.backgroundColor = UIColor.CL
        
        slMainLbl.textColor = UIColor.SL
        slBarView.backgroundColor = UIColor.SL
        
        coMainLbl.textColor = UIColor.comppOff
        coBarView.backgroundColor = UIColor.comppOff
        
        rhMainLbl.textColor = UIColor.RH
        rhBarView.backgroundColor = UIColor.RH
        
        
        let clAvailed = detail.CL?.value(forKeyPath: "Availed") as? Double ?? 0.0
        let clBalance = detail.CL?.value(forKeyPath: "Balance") as? Double ?? 0.0
        let clGranted = detail.CL?.value(forKeyPath: "Granted") as? Double ?? 0.0
        
        let coAvailed = detail.CO?.value(forKeyPath: "Availed") as? Double ?? 0.0
        let coBalance = detail.CO?.value(forKeyPath: "Balance") as? Double ?? 0.0
        let coGranted = detail.CO?.value(forKeyPath: "Granted") as? Double ?? 0.0
        
        let rhAvailed = detail.RH?.value(forKeyPath: "Availed") as? Double ?? 0.0
        let rhBalance = detail.RH?.value(forKeyPath: "Balance") as? Double ?? 0.0
        let rhGranted = detail.RH?.value(forKeyPath: "Granted") as? Double ?? 0.0
        
        let slAvailed = detail.SL?.value(forKeyPath: "Availed") as? Double ?? 0.0
        let slBalance = detail.SL?.value(forKeyPath: "Balance") as? Double ?? 0.0
        let slGranted = detail.SL?.value(forKeyPath: "Granted") as? Double ?? 0.0
        
        let elAvailed = detail.EL?.value(forKeyPath: "Availed") as? Double ?? 0.0
        let elBalance = detail.EL?.value(forKeyPath: "Balance") as? Double ?? 0.0
        let elGranted = detail.EL?.value(forKeyPath: "Granted") as? Double ?? 0.0
        let elCarryFwd = detail.EL?.value(forKeyPath: "CarryForwarded") as? Double ?? 0.0
        
        
        elMainLbl.text = "Earned Leave(\(elBalance))"
        elGrantedLbl.text = "Granted(\(elGranted)) Availed(\(elAvailed))"
        elCarryForwardLbl.text = "Carry Forward(\(elCarryFwd))"
       
        clMainLbl.text = "Casual Leave(\(clBalance))"
        clGrantedLbl.text = "Granted(\(clGranted)) Availed(\(clAvailed))"
        
        slMainLbl.text = "Sick Leave(\(slBalance))"
        slGrantedLbl.text = "Granted(\(slGranted)) Availed(\(slAvailed))"
        
        coMainLbl.text = "Comp-Off(\(coBalance))"
        coGrantedLbl.text = "Granted(\(coGranted)) Availed(\(coAvailed))"
        
        rhMainLbl.text = "Ristricted Holiday(\(rhBalance))"
        rhGrantedLbl.text = "Granted(\(rhGranted)) Availed(\(rhAvailed))"
        
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        self.delegate2?.BacktoNotification1(info: "WentToDetailsVC")
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: ManagerLeaveDetailsVC.self])
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func declineAction(_ sender: Any) {
        
        Analytics.logEvent("decline_action_ios", parameters: [AnalyticsParameterScreenName: ManagerLeaveDetailsVC.self])
        
        if status == "Pending" || status == "Cancelled"{
            shadowView.isHidden = false
            
            reasonView.frame.origin.y = view.frame.height

            // Show the reasonView with slide-up animation
            UIView.animate(withDuration: 0.4, animations: {
                // Slide reasonView up to the center of the screen
                self.reasonView.center.y = self.view.center.y
            })
        }
        else{
            shadowView.isHidden = true
           // changeLeaveStatusCall(guid: guid, status: "Rejected", reason: "", group: nil)
        }
        
       // shadowView.isHidden = false
        
        
    }
    
    
    @IBAction func acceptAction(_ sender: Any) {
        
        Analytics.logEvent("accept_action_ios", parameters: [AnalyticsParameterScreenName: ManagerLeaveDetailsVC.self])
        
        reasonTxtSend = ""
        statusSend = "Approved"
        
        changeLeaveStatusCall(guid: guid, status: statusSend, reason: reasonTxtSend, group: nil)
    }
    
    @IBAction func cancelPopupAction(_ sender: Any) {
        
        Analytics.logEvent("cancelPopup_action_ios", parameters: [AnalyticsParameterScreenName: ManagerLeaveDetailsVC.self])
        //shadowView.isHidden = true
        
        UIView.animate(withDuration: 0.4, animations: {
                // Slide reasonView back down below the screen
                self.reasonView.center.y = self.view.frame.height + self.reasonView.frame.height
            }) { (_) in
                // After animation completes, hide the shadowView
                self.shadowView.isHidden = true
            }
        
    }
    
    
    @IBAction func submitPopupAction(_ sender: Any) {
        
        Analytics.logEvent("submit_action_ios", parameters: [AnalyticsParameterScreenName: ManagerLeaveDetailsVC.self])
        
        if validateSignUpDetails() {
            
            reasonTxtSend = String(describing: reasonTxtView.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            if self.status == "Pending"{
                statusSend = "Disapproved"
                changeLeaveStatusCall(guid: guid, status: statusSend, reason: reasonTxtSend, group: nil)
            }
            else{
                statusSend = "Rejected"
                changeLeaveStatusCall(guid: guid, status: statusSend, reason: reasonTxtSend, group: nil)
            }
            
        }
    }
    
    //================================
            //MARK: - Validation Fields
    //================================
            func validateSignUpDetails () -> Bool {

                if reasonTxtView.text?.trimmingCharacters(in: .whitespaces).count == 0 {

                    // Show Alert
                    self.showMessage("Please provide a reason for the decline.")
                    //self.showMessage("Error", "Please enter Reason.")
                    reasonTxtView.resignFirstResponder()
                    return false

                }

                return true
            }
    
}

extension ManagerLeaveDetailsVC{
    
    
    func leaveSummaryDetailCall(guid: String, notiguid: String, group: DispatchGroup?){
       
        let viewModel = dashboardViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                    //self!.showIndicator(withTitle: "Loading...")
                    self?.showGif()
                   
                } else {
                    //self!.hideIndicator()
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

            DispatchQueue.main.async {
                
                group?.leave()
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 401{
                    
                    self.fromRefresh = "Summary Detail"
                    
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
                   self!.showIndicator(withTitle: "Loading...")
                   
                } else {
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
                
                group?.leave()
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 401{
                    
                    self.fromRefresh = "Change Status"
                    
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
                            self.shadowView.isHidden = true
                            self.delegate?.BackToPreviousReq(info: "")
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
        
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
                    //self!.showIndicator(withTitle: "Loading...")
                    self?.showGif()
                   
                } else {
                    //self!.hideIndicator()
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

            DispatchQueue.main.async {
                
                group?.leave()
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 200{
                    
                    if self.fromRefresh == "Summary Detail"{
                        self.leaveSummaryDetailCall(guid: self.guid, notiguid: self.notificationguid, group: nil)
                    }
                    else{
                        self.changeLeaveStatusCall(guid: self.guid, status: self.statusSend, reason: self.reasonTxtSend, group: nil)
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

extension ManagerLeaveDetailsVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Release the audio player once it's done playing
        audioPlayer = nil
        
        retainSelf = nil
    }
}
