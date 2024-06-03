//
//  ApplyRequestVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 13/04/23.
//

import UIKit
import IBAnimatable
import Alamofire
import CoreLocation
import FirebaseAnalytics
import AVFoundation

class ApplyRequestVC: UIViewController, CLLocationManagerDelegate, backToHoliday, UITextFieldDelegate {

    @IBOutlet weak var balanceTitleLblWidth: NSLayoutConstraint!
    @IBOutlet weak var balanceTitleLbl: UILabel!
    @IBOutlet weak var workLocationView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var workLocationTxtFld: AnimatableTextField!
    @IBOutlet weak var sessionTwoBtn: UIButton!
    @IBOutlet weak var sessionOneBtn: UIButton!
    @IBOutlet weak var mobileNumberTxtFld: AnimatableTextField!
    @IBOutlet weak var reasonTxtView: AnimatableTextView!
    @IBOutlet weak var ccLbl: UILabel!
    @IBOutlet weak var applyingToLbl: UILabel!
    @IBOutlet weak var toSessionLbl: UILabel!
    @IBOutlet weak var fromSessionLbl: UILabel!
    @IBOutlet weak var grantTyleLbl: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var toDateTxtFld: AnimatableTextField!
    @IBOutlet weak var fromDateTxtFld: AnimatableTextField!
    @IBOutlet weak var daysLbl: UILabel!
    
    @IBOutlet weak var newToTxtFld: UITextField!
    @IBOutlet weak var newFromTxtFld: UITextField!
    
    @IBOutlet weak var grantTypeTapBtn: UIButton!
    @IBOutlet var ccTypeBtn: UIButton!
    
    @IBOutlet var fromSessionView: UIView!
    @IBOutlet var fromSessionHeadingLbl: UILabel!
    @IBOutlet var fromSessionArrowImage: UIImageView!
    @IBOutlet var halfDayToggleSwitch: UISwitch!
    
    @IBOutlet var toSessionHeadingLbl: UILabel!
    @IBOutlet var toSessionArrowImage: UIImageView!
    @IBOutlet var toSessionView: UIView!
    
    //new code for half day
    var halfDayToggle = true
    var isHalfDay = false
    
    var calDate = ""
    var comeFromCal = ""
    var comeFrom = ""
    var type = ""
    
    var countryName = ""
    
    var leaveBal = Double()
    
    var loader = Loader()
    
    private let locationManager = CLLocationManager()
    
    var managerListArr = NSArray()
    var leaveArr = NSArray()
    var sessionArr = NSArray()
    
    var managerMutableArr = NSMutableArray()
    var leaveMutableArr = NSMutableArray()
    var sessionMutableArr = NSMutableArray()
    
    var managerEmail = String()
    var ccMnagerEmail = String()
    
    var applyingto = String()
    
    var leavedays : LeaveDays?
    
    var statusCode = Int()
    
    var fromRefresh = String()
    
    var comeFromHolidays = String()
    
    var holidaylist : holidayList?
    
    
    var sessioFromFordays : String?
    var sessionToFordays : String?
    var startDateFordays : String?
    var endDateFordays : String?
    var TypeFordays : String?
    var timeStartDateForDays : String?
    var timeToDateForDays : String?
    
    var rhHolidayName : String?
    
    var callGetDays : String?
    
    //audio code
    var audioPlayer: AVAudioPlayer?
    var retainSelf: ApplyRequestVC?
    
    /*new location code*/
    var locationServicesCheck = true
    var secondCheck = true
    /*new location code is upto here*/
    
    private lazy var datePicker: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
      datePicker.datePickerMode = .date
        datePicker.date = Date()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
      datePicker.timeZone = TimeZone.current
      return datePicker
    }()
    
    private lazy var datePickerToDate: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
      datePicker.datePickerMode = .date
       // datePicker.maximumDate = Date()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
      datePicker.timeZone = TimeZone.current
      return datePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //fatalError("Testing")
        
        // Do any additional setup after loading the view.
        
        
        /*new location code*/
        //NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        /*new location code is upto here*/
        
        retainSelf = self
        
        self.getDropdownData()
        
        grantTypeTapBtn.isUserInteractionEnabled = false
        ccTypeBtn.isUserInteractionEnabled = false
        sessionOneBtn.isUserInteractionEnabled = false
        sessionTwoBtn.isUserInteractionEnabled = false
        
        mobileNumberTxtFld.delegate = self
        workLocationView.isHidden = true

//        /*new location code*/
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.distanceFilter = 15
//            locationManager.startUpdatingLocation() // Request permission when the app is in use
//        } else {
//            
//            print("Location services are not enabled")
//            let alertController = UIAlertController(title: "Location Permission Required", message: "WMS needs access to your location. Turn on Location Services in your device settings.", preferredStyle: .alert)
//            
//                                let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
//                                    //Redirect to Settings app
//                                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//                                })
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
//            
//                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainVC") as! HomeMainVC
//                        self.navigationController?.pushViewController(secondViewController, animated: false)
//            
//                    }
//            
//                                alertController.addAction(cancelAction)
//            
//                                alertController.addAction(okAction)
//            
//                                self.present(alertController, animated: true, completion: nil)
//        }
//        /*new location code is upto here*/
//        
        
        if comeFrom == "Home" || comeFrom == "Holidays"{
            backBtn.isHidden = false
            
            let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBack(_:)))
            swipeRight.edges = .left
            view.addGestureRecognizer(swipeRight)
            
           // grantTyleLbl.text = type
            balanceLbl.text = "\(leaveBal)"
            
        }
        else{
            backBtn.isHidden = true
            balanceLbl.text = "0"
        }
        
        
        if comeFromCal == "Calender"{
          //  backBtn.isHidden = false
            
            print(calDate)
            
           // let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
           // let newToDate = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            fromDateTxtFld.text = calDate.convertdateStringtoNewFormat(currentFormat: "YYYY-MM-dd", toFormat: "dd/MM/yyyy")
            toDateTxtFld.text = calDate.convertdateStringtoNewFormat(currentFormat: "YYYY-MM-dd", toFormat: "dd/MM/yyyy")
           // grantTyleLbl.text = "Select Transaction Type"
            
        }
        else{
           // backBtn.isHidden = true
            fromDateTxtFld.text = Date.getCurrentDateChangeNew()
            toDateTxtFld.text = Date.getCurrentDateChangeNew()
           // grantTyleLbl.text = "Select Transaction Type"
        }
        
        if type != ""{
            grantTyleLbl.text = type
        }
        else{
            grantTyleLbl.text = "Select Transaction Type"
        }
        
        if type == "Earned Leave"{
            
            toSessionView.isHidden = false
            
            sessionOneBtn.isUserInteractionEnabled = false
            sessionTwoBtn.isUserInteractionEnabled = false
            
            fromSessionLbl.text = "Session 1"
            toSessionLbl.text = "Session 2"
            
            fromSessionHeadingLbl.text = "From Session"
            
//            toSessionLbl.textColor = .black
//            toSessionHeadingLbl.textColor = .black
//            toSessionView.isUserInteractionEnabled = true
//            toSessionArrowImage.alpha = 1.0
            
            halfDayToggleSwitch.isOn = false
            
            halfDayToggleSwitch.isUserInteractionEnabled = false
        }
        else{
            
            halfDayToggle = true
            
            halfDayToggleSwitch.isUserInteractionEnabled = true
            
            sessionOneBtn.isUserInteractionEnabled = true
            sessionTwoBtn.isUserInteractionEnabled = true
        }
        
        
        fromDateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedFrom))
        toDateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedTo))
        
        newFromTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedFrom))
        newToTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedTo))
        
        fromDateTxtFld.tintColor = .clear
        toDateTxtFld.tintColor = .clear
        
        newFromTxtFld.tintColor = .clear
        newToTxtFld.tintColor = .clear
        
        newFromTxtFld.inputView = datePicker
        fromDateTxtFld.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        
       // datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        newToTxtFld.inputView = datePickerToDate
        toDateTxtFld.inputView = datePickerToDate
        datePickerToDate.addTarget(self, action: #selector(handleDatePickerToDate(sender:)), for: .valueChanged)
        
        
      //  datePicker.addTarget(self, action: #selector(handleDatePickerToDate(sender:)), for: .valueChanged)
        
       // reasonTxtView.layer.cornerRadius = reasonTxtView.frame.size.height/2
        reasonTxtView.clipsToBounds = true
        reasonTxtView.layer.shadowOpacity = 0.3
        reasonTxtView.layer.shadowOffset = CGSizeMake(3, 3)
        reasonTxtView.layer.shadowColor = UIColor.lightGray.cgColor
        
      //  getLeaveDaysCall(type: "", startdate: "", enddate: "", sessionstart: "Session1", sessionend: "Session1", isovertime: false, group: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: ApplyRequestVC.self,
            AnalyticsParameterScreenClass: ApplyRequestVC.self])
    }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        ActivityLoader.shared.hideLoader()
//    }
    
    /*new location code*/
//    @objc func appDidBecomeActive() {
//            // Add your code here to handle the app becoming active
//            print("App did become active in YourViewController")
//        
//        if locationServicesCheck == true{
//            
//            if CLLocationManager.locationServicesEnabled() {
//                
//                //locationServicesCheck = false
//                
//                locationManager.delegate = self
//                locationManager.requestWhenInUseAuthorization()
//                locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                locationManager.requestAlwaysAuthorization()
//                locationManager.distanceFilter = 15
//                locationManager.startUpdatingLocation() // Request permission when the app is in use
//            } else {
//                                // Handle the case where location services are not enabled
//            }
//            
//        }else{
//            //NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
//
//        }
//        
//            
//        
//        }
    /*new location code is upto here*/
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

                if textField == mobileNumberTxtFld {

                    let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""

                    let digitCount = updatedText.count
                    
                    if digitCount > 10 {

                        return false

                    }

                }

                return true

            }
    
    
    func BackHoliday(holiday: String) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
     //   ActivityLoader.shared.hideLoader()
        
        // Set up the initial date in the text field
            //fromDateTxtFld.text = dateFormatter.string(from: datePicker.date)

        datePicker.date = Date()
        datePickerToDate.date = Date()
        
            // Set the input view for the text field
            fromDateTxtFld.inputView = datePicker
            newFromTxtFld.inputView = datePicker
            // Add target for value changes in the date picker
            datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        
        newFromTxtFld.inputView = datePicker
        fromDateTxtFld.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        
       // datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        newToTxtFld.inputView = datePickerToDate
        toDateTxtFld.inputView = datePickerToDate
        datePickerToDate.addTarget(self, action: #selector(handleDatePickerToDate(sender:)), for: .valueChanged)
        
        grantTyleLbl.text = "Select Transaction Type"
        mobileNumberTxtFld.text = ""
        ccLbl.text = "Select Manager"
        reasonTxtView.text = ""
        workLocationTxtFld.text = ""
        fromSessionLbl.text = "Session 1"
        toSessionLbl.text = "Session 2"
        
        isHalfDay = false
        halfDayToggleSwitch.isOn = false
        toSessionView.isHidden = false
        fromSessionHeadingLbl.text = "From Session"
        
        
        if comeFrom == "Home" || comeFrom == "Holidays"{
            backBtn.isHidden = false
           // grantTyleLbl.text = type
        }
        else{
            backBtn.isHidden = true
        }
        
        
        if comeFromCal == "Calender"{
          //  backBtn.isHidden = false
            fromDateTxtFld.text = calDate.convertdateStringtoNewFormat(currentFormat: "YYYY-MM-dd", toFormat: "dd/MM/yyyy")
            toDateTxtFld.text = calDate.convertdateStringtoNewFormat(currentFormat: "YYYY-MM-dd", toFormat: "dd/MM/yyyy")
           // grantTyleLbl.text = "Select Transaction Type"
            
        }
        else{
           // backBtn.isHidden = true
            fromDateTxtFld.text = Date.getCurrentDateChangeNew()
            toDateTxtFld.text = Date.getCurrentDateChangeNew()
           // grantTyleLbl.text = "Select Transaction Type"
        }
        
        if type != ""{
            grantTyleLbl.text = type
        }
        else{
            grantTyleLbl.text = "Select Transaction Type"
        }
        
        if type == "Earned Leave"{
            
            toSessionView.isHidden = false
            
            sessionOneBtn.isUserInteractionEnabled = false
            sessionTwoBtn.isUserInteractionEnabled = false
            
            fromSessionLbl.text = "Session 1"
            toSessionLbl.text = "Session 2"
            
            fromSessionHeadingLbl.text = "From Session"
            
            toSessionLbl.textColor = .black
            toSessionHeadingLbl.textColor = .black
            toSessionView.isUserInteractionEnabled = true
            toSessionArrowImage.alpha = 1.0
            
            halfDayToggleSwitch.isOn = false
            
            halfDayToggleSwitch.isUserInteractionEnabled = false
        }
        else{
            
            halfDayToggle = true
            
            halfDayToggleSwitch.isUserInteractionEnabled = true
            
            sessionOneBtn.isUserInteractionEnabled = true
            sessionTwoBtn.isUserInteractionEnabled = true
        }
        
    }
    
//    func hasLocationPermission() -> Bool {
//        var hasPermission = false
//        let manager = CLLocationManager()
//
//        if CLLocationManager.locationServicesEnabled() {
//            switch manager.authorizationStatus {
//            case .notDetermined, .restricted, .denied:
//                hasPermission = false
//            case .authorizedAlways, .authorizedWhenInUse:
//                hasPermission = true
//            @unknown default:
//                    break
//            }
//        } else {
//            hasPermission = false
//        }
//
//        return hasPermission
//    }
    
    
    //================================
       //MARK: - location delegate methods
   //================================
    
    
    // Function to show an alert for location permission
//            func showLocationPermissionAlert() {
//                let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
//     
//                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
//                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
//                        UIApplication.shared.open(settingsURL)
//                    }
//                }
//     
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//                    // Handle cancellation if needed
//                }
//     
//                alertController.addAction(settingsAction)
//                alertController.addAction(cancelAction)
//     
//                self.present(alertController, animated: true, completion: nil)
//            }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//        switch status {
//    
//            case .authorizedWhenInUse, .authorizedAlways: break
//                    // Permission granted, you can start using location services
//                case .denied, .restricted:
//                    // Permission denied or restricted, show an alert to guide the user to settings
//                    showLocationPermissionAlert()
//                case .notDetermined: break
//                    // Permission not determined yet
//                @unknown default:
//                    break
//                }
//        
//        
////        if status == .authorizedWhenInUse {
////             locationManager.requestLocation()
////         }
//        
// //       if !CLLocationManager.locationServicesEnabled() {
// //           //showAlert(msg: "Invalid Permission")
// //           showMessage("Invalid Permission")
// //      }
//    }
    
//   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//       
//        // Show Loder
//      //  loader.addLoader(view: self.view)
//       
//       let User_Location = CLLocation(latitude: manager.location?.coordinate.latitude ?? 0.0, longitude: manager.location?.coordinate.longitude ?? 0.0)
//        self.reverseGeocodeCoordinate(coordinate: User_Location)
//       self.locationManager.stopUpdatingLocation()
//   }
    
    
    
//   func reverseGeocodeCoordinate(coordinate: CLLocation) {
//       let geocoder = CLGeocoder()
//       geocoder.reverseGeocodeLocation(coordinate, completionHandler: {
//           placemarks, error in
//           if (error != nil) {
//               print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
//               return
//           }
//           if (placemarks?.count)! > 0 {
//               
//               let placeMarkers = placemarks![0]
//               
//              print(placeMarkers.country ?? "")
//               UserDefaults.standard.set(placeMarkers.country ?? "", forKey: "CountryName")
//               
//               /*new location code*/
//               if self.secondCheck == true{
//                   self.getDropdownData()
//                   self.secondCheck = false
//               }else{
//                   
//               }
//               /*new location code is upto here*/
//               
//           }
//       })
//   }
   
   
    @objc func handleDatePicker(sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd/MM/yyyy"
          fromDateTxtFld.text = dateFormatter.string(from: sender.date)
        
     }
    
    @objc func handleDatePickerToDate(sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd/MM/yyyy"
          toDateTxtFld.text = dateFormatter.string(from: sender.date)
        
     }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: ApplyRequestVC.self])
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        
        Analytics.logEvent("cancel_action_ios", parameters: [AnalyticsParameterScreenName: ApplyRequestVC.self])
        
        if comeFrom == "Home" || comeFrom == "Holidays" || comeFrom == "Calender"{
           
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.tabBarController?.selectedIndex = 0
        }
        
        
    }
    
    
    func sendApi(){
        
        if validateSignUpDetails() { // Check Validation

            let type = grantTyleLbl.text!
            let startdate = String(describing: fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let todate = String(describing: toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let worklocation = String(describing: workLocationTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            let newToDate = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            //print(formattedDate)
            let timeStartDate = "\(newStartDate)\(formattedDate)"
            
            let dateFormatterTo = DateFormatter()
            dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            dateFormatterTo.timeZone = TimeZone(abbreviation: "UTC")
            let currentDateTo = Date()
            let formattedDateTo = dateFormatterTo.string(from: currentDate)
            //print(formattedDate)
            let timeToDate = "\(newToDate)\(formattedDateTo)"
            
            
            var startsession = fromSessionLbl.text!
            var endsession = toSessionLbl.text!
            let applyingto = applyingToLbl.text!
            let mobilenumber = mobileNumberTxtFld.text!
            let ccTxt = ccLbl.text!
            let ramarks = reasonTxtView.text!
            
            if isHalfDay == true{
                endsession = fromSessionLbl.text!
            }else{
                endsession = toSessionLbl.text!
            }
            
            if grantTyleLbl.text == "WFH"{
                // Call Apply Leave Api
                applyWFHCall(type: type, startdate: timeStartDate, enddate: timeToDate, sessionstart: startsession, sessionend: endsession, workLocation: worklocation, applyto: applyingto, manageremail: self.managerEmail, remarks: ramarks, isHalfDay: self.isHalfDay, group: nil)
            }
            else{
                // Call Apply Leave Api
                applyLeaveCall(type: type, startdate: timeStartDate, enddate: timeToDate, sessionstart: startsession, sessionend: endsession, mobilenumber: mobilenumber, applyto: applyingto, manageremail: self.managerEmail, remarks: ramarks, isHalfDay: self.isHalfDay, group: nil)
            }


        }
    }
    
    @IBAction func halfDayToggleBtn(_ sender: UISwitch) {
        
        if halfDayToggleSwitch.isOn == true{
          
            fromSessionHeadingLbl.text = "Session"
            halfDayToggle = true
            isHalfDay = halfDayToggle
            
            toSessionView.isHidden = true
            
            self.getLeaveDaysCall(type: self.TypeFordays ?? "", startdate: self.timeStartDateForDays ?? "", enddate: self.timeToDateForDays ?? "", sessionstart: self.fromSessionLbl.text ?? "", sessionend: self.fromSessionLbl.text ?? "", isovertime: false, isHalfDay: self.isHalfDay, group: nil)
            
        }else{
            print(halfDayToggle)
            
            fromSessionHeadingLbl.text = "From Session"
            
          //  halfDayToggle = true
            halfDayToggle = false
            isHalfDay = halfDayToggle
            
            toSessionView.isHidden = false
            
            self.getLeaveDaysCall(type: self.TypeFordays ?? "", startdate: self.timeStartDateForDays ?? "", enddate: self.timeToDateForDays ?? "", sessionstart: self.fromSessionLbl.text ?? "", sessionend: self.toSessionLbl.text ?? "", isovertime: false, isHalfDay: self.isHalfDay, group: nil)
        }
        
        
    }
    
    
    @IBAction func applyAction(_ sender: Any) {
        
        Analytics.logEvent("apply_action_ios", parameters: [AnalyticsParameterScreenName: ApplyRequestVC.self])
        
        sendApi()
    }
    
    
    @IBAction func grantTypeAction(_ sender: Any) {
        
        leaveMutableArr.removeAllObjects()
        
        for index in 0...self.leaveArr.count-1 {
            
            let dict = leaveArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.leaveMutableArr.add(String(title))
        }

        RPicker.selectOption(dataArray: (leaveMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.leaveArr[atIndex] as? NSDictionary ?? [:]
            
           // self?.countryId = dict.value(forKeyPath: "id") as? Int ?? 0
            
            self!.grantTyleLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
             
            let type = dict.value(forKeyPath: "Text") as? String ?? ""
            
            
//            if type == "Leave Without Pay"{
//                self!.balanceLbl.text = "0"
//            }
//            else{
                self!.balanceLbl.text = "\(dict.value(forKeyPath: "Value") as? String ?? "")"
//            }
            
            
            if type == "Restricted Holiday"{
                
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "RHApplyVC") as! RHApplyVC
                vc.ccArr = self!.managerListArr
                vc.applyingTo = self!.applyingto
                vc.manageremail = self!.managerEmail
                vc.comefrom = "Apply"
                vc.modalPresentationStyle = .overFullScreen
                self!.present(vc, animated: true, completion: nil)
                
            }
            
            if type == "Earned Leave"{
                
                self!.toSessionView.isHidden = false
                
                self!.sessionOneBtn.isUserInteractionEnabled = false
                self!.sessionTwoBtn.isUserInteractionEnabled = false
                
                self!.fromSessionLbl.text = "Session 1"
                self!.toSessionLbl.text = "Session 2"
                
                self!.fromSessionHeadingLbl.text = "From Session"
                
                self!.toSessionLbl.textColor = .black
                self!.toSessionHeadingLbl.textColor = .black
                self!.toSessionView.isUserInteractionEnabled = true
                self!.toSessionArrowImage.alpha = 1.0
                
                self!.halfDayToggleSwitch.isOn = false
                
                self!.halfDayToggleSwitch.isUserInteractionEnabled = false
            }
            else{
                
                self!.halfDayToggle = true
                
                self!.halfDayToggleSwitch.isUserInteractionEnabled = true
                
                self!.sessionOneBtn.isUserInteractionEnabled = true
                self!.sessionTwoBtn.isUserInteractionEnabled = true
            }
            
            if type == "WFH"{
                self!.workLocationView.isHidden = false
                self!.mobileNumberView.isHidden = true
                self!.balanceTitleLbl.isHidden = true
                self!.balanceTitleLblWidth.constant = 20
                self!.balanceLbl.isHidden = true
            }
            else{
                self!.workLocationView.isHidden = true
                self!.mobileNumberView.isHidden = false
                self!.balanceTitleLbl.isHidden = false
                self!.balanceTitleLblWidth.constant = 70
                self!.balanceLbl.isHidden = false
            }
            
            
            if self!.fromDateTxtFld.text != "" && self!.toDateTxtFld.text != ""{
                
                self!.TypeFordays = self!.grantTyleLbl.text!
                
                let startdate = String(describing: self!.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                let todate = String(describing: self!.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                
                self!.sessioFromFordays = self!.fromSessionLbl.text!
                self!.sessionToFordays = self!.toSessionLbl.text!
                
                
                self!.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                self!.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let currentDate = Date()
                let formattedDate = dateFormatter.string(from: currentDate)
                //print(formattedDate)
                self!.timeStartDateForDays = "\(self!.startDateFordays ?? "")\(formattedDate)"
                
                let dateFormatterTo = DateFormatter()
                dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                dateFormatterTo.timeZone = TimeZone(abbreviation: "UTC")
                let currentDateTo = Date()
                let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
                //print(formattedDate)
                self!.timeToDateForDays = "\(self!.endDateFordays ?? "")\(formattedDateTo)"
                
                if self!.isHalfDay == true{
                    self!.sessionToFordays = self!.fromSessionLbl.text!
                }else{
                    self!.sessionToFordays = self!.toSessionLbl.text!
                }
                
                self!.getLeaveDaysCall(type: self!.TypeFordays ?? "", startdate: self!.timeStartDateForDays ?? "", enddate: self!.timeToDateForDays ?? "", sessionstart: self!.sessioFromFordays ?? "", sessionend: self!.sessionToFordays ?? "", isovertime: false, isHalfDay: self!.isHalfDay, group: nil)
                
                
            }
            
            
                
        }
        
    }
    
    
    @IBAction func fromSessionAction(_ sender: Any) {
        
        sessionMutableArr.removeAllObjects()
        
        for index in 0...self.sessionArr.count-1 {
            
            let dict = sessionArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.sessionMutableArr.add(String(title))
        }

        RPicker.selectOption(dataArray: (sessionMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.sessionArr[atIndex] as? NSDictionary ?? [:]
            
           // self?.countryId = dict.value(forKeyPath: "id") as? Int ?? 0
            
            self!.fromSessionLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
             
            if self!.fromDateTxtFld.text != "" && self!.toDateTxtFld.text != ""{
                
                self!.TypeFordays = self!.grantTyleLbl.text!
                
                let startdate = String(describing: self!.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                let todate = String(describing: self!.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                
                self!.sessioFromFordays = self!.fromSessionLbl.text!
                self!.sessionToFordays = self!.toSessionLbl.text!
                
                
                self!.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                self!.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let currentDate = Date()
                let formattedDate = dateFormatter.string(from: currentDate)
                //print(formattedDate)
                self!.timeStartDateForDays = "\(self!.startDateFordays ?? "")\(formattedDate)"
                
                let dateFormatterTo = DateFormatter()
                dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                dateFormatterTo.timeZone = TimeZone(abbreviation: "UTC")
                let currentDateTo = Date()
                let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
                //print(formattedDate)
                self!.timeToDateForDays = "\(self!.endDateFordays ?? "")\(formattedDateTo)"
                
                if self!.isHalfDay == true{
                    self!.sessionToFordays = self!.fromSessionLbl.text!
                }else{
                    self!.sessionToFordays = self!.toSessionLbl.text!
                }
                
                self!.getLeaveDaysCall(type: self!.TypeFordays ?? "", startdate: self!.timeStartDateForDays ?? "", enddate: self!.timeToDateForDays ?? "", sessionstart: self!.sessioFromFordays ?? "", sessionend: self!.sessionToFordays ?? "", isovertime: false, isHalfDay: self!.isHalfDay, group: nil)
                
                
            }
            
                
        }
       
    }
    
    
    @IBAction func toSessionAction(_ sender: Any) {
        
        sessionMutableArr.removeAllObjects()
        
        for index in 0...self.sessionArr.count-1 {
            
            let dict = sessionArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.sessionMutableArr.add(String(title))
        }

        RPicker.selectOption(dataArray: (sessionMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.sessionArr[atIndex] as? NSDictionary ?? [:]
            
           // self?.countryId = dict.value(forKeyPath: "id") as? Int ?? 0
            
            self!.toSessionLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
             
            
            if self!.fromDateTxtFld.text != "" && self!.toDateTxtFld.text != ""{
                
                self!.TypeFordays = self!.grantTyleLbl.text!
                
                let startdate = String(describing: self!.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                let todate = String(describing: self!.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                
                self!.sessioFromFordays = self!.fromSessionLbl.text!
                self!.sessionToFordays = self!.toSessionLbl.text!
                
                
                self!.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                self!.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let currentDate = Date()
                let formattedDate = dateFormatter.string(from: currentDate)
                //print(formattedDate)
                self!.timeStartDateForDays = "\(self!.startDateFordays ?? "")\(formattedDate)"
                
                let dateFormatterTo = DateFormatter()
                dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                dateFormatterTo.timeZone = TimeZone(abbreviation: "UTC")
                let currentDateTo = Date()
                let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
                //print(formattedDate)
                self!.timeToDateForDays = "\(self!.endDateFordays ?? "")\(formattedDateTo)"
                
                if self!.isHalfDay == true{
                    self!.sessionToFordays = self!.fromSessionLbl.text!
                }else{
                    self!.sessionToFordays = self!.toSessionLbl.text!
                }
                
                self!.getLeaveDaysCall(type: self!.TypeFordays ?? "", startdate: self!.timeStartDateForDays ?? "", enddate: self!.timeToDateForDays ?? "", sessionstart: self!.sessioFromFordays ?? "", sessionend: self!.sessionToFordays ?? "", isovertime: false, isHalfDay: self!.isHalfDay, group: nil)
                
                
            }
            
                
        }
        
    }
    
    @IBAction func ccAction(_ sender: Any) {
        
        managerMutableArr.removeAllObjects()
        
        for index in 0...self.managerListArr.count-1 {
            
            let dict = managerListArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.managerMutableArr.add(String(title))
        }

        RPicker.selectOption(dataArray: (managerMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.managerListArr[atIndex] as? NSDictionary ?? [:]
            
           // self?.countryId = dict.value(forKeyPath: "id") as? Int ?? 0
            
            self!.ccLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
             
           // self!.type = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.ccMnagerEmail = dict.value(forKeyPath: "Value") as? String ?? ""
            
            //self!.setIsMyRequests(isMyRequest: true, leaveType: self!.type, leaveStatus: self!.status, leaveFrom: self!.fromdate)
            
                
        }
    }
    

    @objc func doneButtonClickedFrom(_ sender: Any) {
        
        if fromDateTxtFld.text != "" && toDateTxtFld.text != ""{
            
            self.TypeFordays = self.grantTyleLbl.text!
            
            let startdate = String(describing: self.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let todate = String(describing: self.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            self.sessioFromFordays = self.fromSessionLbl.text!
            self.sessionToFordays = self.toSessionLbl.text!
            
            
            self.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            self.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            //print(formattedDate)
            self.timeStartDateForDays = "\(self.startDateFordays ?? "")\(formattedDate)"
            
            let dateFormatterTo = DateFormatter()
            dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            dateFormatterTo.timeZone = TimeZone(abbreviation: "UTC")
            let currentDateTo = Date()
            let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
            //print(formattedDate)
            self.timeToDateForDays = "\(self.endDateFordays ?? "")\(formattedDateTo)"
            
            if self.isHalfDay == true{
                self.sessionToFordays = self.fromSessionLbl.text!
            }else{
                self.sessionToFordays = self.toSessionLbl.text!
            }
            
            self.getLeaveDaysCall(type: self.TypeFordays ?? "", startdate: self.timeStartDateForDays ?? "", enddate: self.timeToDateForDays ?? "", sessionstart: self.sessioFromFordays ?? "", sessionend: self.sessionToFordays ?? "", isovertime: false, isHalfDay: self.isHalfDay, group: nil)
            
            
        }
        
    }
    
    @objc func doneButtonClickedTo(_ sender: Any) {
        if fromDateTxtFld.text != "" && toDateTxtFld.text != ""{
            
            self.TypeFordays = self.grantTyleLbl.text!
            
            let startdate = String(describing: self.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let todate = String(describing: self.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            self.sessioFromFordays = self.fromSessionLbl.text!
            self.sessionToFordays = self.toSessionLbl.text!
            
            
            self.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            self.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            //print(formattedDate)
            self.timeStartDateForDays = "\(self.startDateFordays ?? "")\(formattedDate)"
            
            let dateFormatterTo = DateFormatter()
            dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            dateFormatterTo.timeZone = TimeZone(abbreviation: "UTC")
            let currentDateTo = Date()
            let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
            //print(formattedDate)
            self.timeToDateForDays = "\(self.endDateFordays ?? "")\(formattedDateTo)"
            
            if self.isHalfDay == true{
                self.sessionToFordays = self.fromSessionLbl.text!
            }else{
                self.sessionToFordays = self.toSessionLbl.text!
            }
            
            self.getLeaveDaysCall(type: self.TypeFordays ?? "", startdate: self.timeStartDateForDays ?? "", enddate: self.timeToDateForDays ?? "", sessionstart: self.sessioFromFordays ?? "", sessionend: self.sessionToFordays ?? "", isovertime: false, isHalfDay: self.isHalfDay, group: nil)
            
            
        }
        
    }
    
    
    //================================
            //MARK: - Validation Fields
    //================================
            func validateSignUpDetails () -> Bool {

                
                if grantTyleLbl.text == "WFH"{
                    if grantTyleLbl.text == "Select Transaction Type"{
                        // Show Alert
                        //self.showMessage("Please select transaction type")
                        self.showMessage("Error", "Please choose a transaction type.")
                       // emailTxtFld.resignFirstResponder()
                        return false
                    }
                    
                    else if fromDateTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0 {

                        // Show Alert
                        self.showMessage("Please enter Start Date")
                       // emailTxtFld.resignFirstResponder()
                        return false

                    }

                    else if toDateTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0{

                        // Show Alert
                        self.showMessage("Please enter End Date")
                       // emailTxtFld.resignFirstResponder()
                        return false
                    }
                    
                    else if workLocationTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0{

                        // Show Alert
                        //self.showMessage("Please enter Work Location")
                        self.showMessage("Error", "Kindly input the work location.")
                       // emailTxtFld.resignFirstResponder()
                        return false
                    }
                }
                else{
                    if grantTyleLbl.text == "Select Transaction Type"{
                        // Show Alert
                        //self.showMessage("Please select transaction type")
                        self.showMessage("Error", "Please choose a transaction type.")
                       // emailTxtFld.resignFirstResponder()
                        return false
                    }
                    
                    else if fromDateTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0 {

                        // Show Alert
                        self.showMessage("Please enter Start Date")
                       // emailTxtFld.resignFirstResponder()
                        return false

                    }

                    else if toDateTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0{

                        // Show Alert
                        self.showMessage("Please enter End Date")
                       // emailTxtFld.resignFirstResponder()
                        return false
                    }
                }
                
                return true
            }
    

}

extension ApplyRequestVC{
    
    
    //================================
    //MARK: - Api's Response
    //================================
    //    MARK: - Call Country Listing APi
    
    func getDropdownData() {
        
        // Show Loder
       // loader.addLoader(view: self.view)
        self.showIndicator(withTitle: "Loading...")
       // ActivityLoader.shared.showLoaderCentered()
        
        // Get AutorizationToken
        // let AutorizationToken = UserDefaults.standard.string(forKey: "UserAuthorisationToken") ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
        ]
        
        AF.request("\(APIConstants.Collective.authBaseURL)ApplyRequest/GetLeaveFilter", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
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
                //  ActivityLoader.shared.hideLoader()
                    
                    let data = json.value(forKey: "Data") as? NSDictionary ?? [:]
                    
                    self.managerListArr = data.value(forKeyPath: "ManagerList") as? NSArray ?? []
                    self.leaveArr = data.value(forKeyPath: "LeaveList") as? NSArray ?? []
                    self.sessionArr = data.value(forKeyPath: "SessionList") as? NSArray ?? []
                    
                    self.grantTypeTapBtn.isUserInteractionEnabled = true
                    self.ccTypeBtn.isUserInteractionEnabled = true
                    
                    
                    if self.grantTyleLbl.text == "Earned Leave"{
                        
                        self.toSessionView.isHidden = false
                        
                        self.sessionOneBtn.isUserInteractionEnabled = false
                        self.sessionTwoBtn.isUserInteractionEnabled = false
                    }
                    else{
                        self.sessionOneBtn.isUserInteractionEnabled = true
                        self.sessionTwoBtn.isUserInteractionEnabled = true
                    }
                    
                   // self.sessionOneBtn.isUserInteractionEnabled = true
                   // self.sessionTwoBtn.isUserInteractionEnabled = true
                    
                    self.applyingto = data.value(forKeyPath: "ApplyingTo") as? String ?? ""
                    self.managerEmail = data.value(forKeyPath: "ManagerEmail") as? String ?? ""
                    
                    self.applyingToLbl.text = self.applyingto
                    
                    if self.type == "Restricted Holiday"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RHApplyVC") as! RHApplyVC
                        vc.ccArr = self.managerListArr
                        vc.applyingTo = self.applyingto
                        vc.manageremail = self.managerEmail
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    
                    
                    if self.comeFromHolidays == "Yes"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RHApplyVC") as! RHApplyVC
                        vc.delegate = self
                        vc.comefrom = "Holiday"
                        vc.holidayList = self.holidaylist
                        vc.applyingTo = self.applyingto
                        vc.ccArr = self.managerListArr
                        vc.manageremail = self.managerEmail
                        vc.rhFinalName = self.rhHolidayName ?? ""
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    
                    self.TypeFordays = self.grantTyleLbl.text!
                    
                    let startdate = String(describing: self.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                    let todate = String(describing: self.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                    
                    self.sessioFromFordays = self.fromSessionLbl.text!
                    self.sessionToFordays = self.toSessionLbl.text!
                    
                    
                    self.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                    self.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    let currentDate = Date()
                    let formattedDate = dateFormatter.string(from: currentDate)
                    //print(formattedDate)
                    self.timeStartDateForDays = "\(self.startDateFordays ?? "")\(formattedDate)"
                    
                    let dateFormatterTo = DateFormatter()
                    dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                    dateFormatterTo.timeZone = TimeZone(abbreviation: "UTC")
                    let currentDateTo = Date()
                    let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
                    //print(formattedDate)
                    self.timeToDateForDays = "\(self.endDateFordays ?? "")\(formattedDateTo)"
                    
                    if self.isHalfDay == true{
                        self.sessionToFordays = self.fromSessionLbl.text!
                    }else{
                        self.sessionToFordays = self.toSessionLbl.text!
                    }
                    
                    
                    if self.callGetDays == "Home"{
                        self.getLeaveDaysCall(type: self.TypeFordays ?? "", startdate: self.timeStartDateForDays ?? "", enddate: self.timeToDateForDays ?? "", sessionstart: self.sessioFromFordays ?? "", sessionend: self.sessionToFordays ?? "", isovertime: false, isHalfDay: false, group: nil)
                    }
                    else{
                        
                    }
                 
                }
                else if status == 401{
                    self.fromRefresh = "Filter"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    // Hide Loader
                    //self.loader.removeLoader(view: self.view)
                    self.hideIndicator()
                    //self.showAlert(msg: message)
                   // ActivityLoader.shared.hideLoader()
                }
            }
            else {
                // Hide Loader
              //  self.loader.removeLoader(view: self.view)
                self.hideIndicator()
               // ActivityLoader.shared.hideLoader()
                
            }
            
        }
    }
    
    
    
    
    func applyWFHCall(type:String, startdate:String, enddate: String, sessionstart: String, sessionend: String, workLocation: String, applyto: String, manageremail: String, remarks: String, isHalfDay: Bool, group: DispatchGroup?){
       
        let viewModel = ApplyRequestViewModel()

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
                        
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainVC") as! HomeMainVC
                        self.navigationController?.pushViewController(secondViewController, animated: false)
                        
                    }
                })
               
                group?.leave()

            }

        }
        viewModel.leaveType = type
        viewModel.startDate = startdate
        viewModel.endDate = enddate
        viewModel.startSession = sessionstart
        viewModel.endSession = sessionend
        viewModel.workLocation = workLocation
        viewModel.applyingTo = applyto
        viewModel.managerEmail = manageremail
        viewModel.ccmanagerEmail = self.ccMnagerEmail
        viewModel.remarks = remarks
        viewModel.timezone = AuthUtils.getOfficeLocation()
        viewModel.isHalfDay = isHalfDay
        viewModel.callApplyLeaveService = true
    }
    
    
    
    
    func applyLeaveCall(type:String, startdate:String, enddate: String, sessionstart: String, sessionend: String, mobilenumber: String, applyto: String, manageremail: String, remarks: String, isHalfDay: Bool, group: DispatchGroup?){
       
        let viewModel = ApplyRequestViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                  //  ActivityLoader.shared.showLoaderCentered()
                    self!.showIndicator(withTitle: "Loading...")
                  //  self!.loader.addLoader(view: self!.view)
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
        viewModel.ccmanagerEmail = self.ccMnagerEmail
        viewModel.remarks = remarks
        viewModel.timezone = AuthUtils.getOfficeLocation()
        viewModel.isHalfDay = isHalfDay
        viewModel.callApplyLeaveService = true
    }
    
    
    
    func getLeaveDaysCall(type:String, startdate:String, enddate: String, sessionstart: String, sessionend: String, isovertime: Bool, isHalfDay:Bool, group: DispatchGroup?){
       
        let viewModel = ApplyRequestViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                   // ActivityLoader.shared.showLoaderCentered()
                    self!.showIndicator(withTitle: "Loading...")
                   // self!.loader.addLoader(view: self!.view)
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
                
                //let blncLbl = self.balanceLbl.text ?? ""
                
               // print((blncLbl))
                
//                if let balance = Double(self.balanceLbl.text ?? ""), let days = Double(self.daysLbl.text ?? "") {
//                            if balance < days {
//                                self.showMessage("Applied days is greater than you balance.")
//                            }
//                        }
                
                
                
                if self.statusCode == 401{
                    
                    self.fromRefresh = "Leave Days"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    self.leavedays = viewModel.leaveDays
                    
                    if self.leavedays?.Days == nil{
                        self.daysLbl.text = "0"
                    }
                    else{
                        self.daysLbl.text = "\(self.leavedays?.Days ?? "")"
                    }
                    
                    
                    if self.grantTyleLbl.text == "WFH"{
                        
                    }
                    else{
                        if let balance = Double(self.balanceLbl.text ?? ""), let days = Double(self.daysLbl.text ?? "") {
                            
                            if self.grantTyleLbl.text == "Select Transaction Type" || self.grantTyleLbl.text == "Leave Without Pay"{
                                
                            }else if balance < days {
                               // self.showMessage("You don't have enough balance")
                                self.showMessage("Error", "Insufficient leave balance available.")
                            }
                            
                            
                        }
                    }
                 
                    
                }
                
                group?.leave()

            }

        }
        viewModel.leaveType = type
        viewModel.startDate = startdate
        viewModel.endDate = enddate
        viewModel.startSession = sessionstart
        viewModel.endSession = sessionend
        viewModel.isOvertime = isovertime
        viewModel.timezone = UserDefaults.standard.string(forKey: "CountryName")
        viewModel.isHalfDay = isHalfDay
        viewModel.callGetLeaveDaysService = true
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
                
                group?.leave()
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 200{
                    
                    if self.fromRefresh == "Filter"{
                        self.getDropdownData()
                    }
                    else if self.fromRefresh == "Apply"{
                        self.sendApi()
                    }
                    else if self.fromRefresh == "Leave Days"{
                        self.getLeaveDaysCall(type: self.TypeFordays ?? "", startdate: self.timeStartDateForDays ?? "", enddate: self.timeToDateForDays ?? "", sessionstart: self.sessioFromFordays ?? "", sessionend: self.sessionToFordays ?? "", isovertime: false, isHalfDay: self.isHalfDay, group: nil)
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

extension ApplyRequestVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Release the audio player once it's done playing
        audioPlayer = nil
        
        retainSelf = nil
    }
}
