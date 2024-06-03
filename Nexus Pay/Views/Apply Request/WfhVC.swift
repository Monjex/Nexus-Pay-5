//
//  WfhVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 08/06/23.
//

import UIKit
import IBAnimatable
import Alamofire
import CoreLocation
import FirebaseAnalytics
import AVFoundation

class WfhVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var newFromDateTxtFld: UITextField!
    @IBOutlet weak var workLocationTxtFld: AnimatableTextField!
   // @IBOutlet weak var mobileNumberTxtFld: AnimatableTextField!
    @IBOutlet weak var ccLbl: UILabel!
    @IBOutlet weak var applyingToLbl: UILabel!
    @IBOutlet weak var toSessionLbl: UILabel!
    @IBOutlet weak var fromSessionLbl: UILabel!
    @IBOutlet weak var grantTyleLbl: UILabel!
    
   // @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var toDateTxtFld: AnimatableTextField!
    @IBOutlet weak var fromDateTxtFld: AnimatableTextField!
    
    @IBOutlet var sessionOneBtn: UIButton!
    @IBOutlet var ccTypeBtn: UIButton!
    
    var comeFrom = ""
    
    var loader = Loader()
    
    var managerListArr = NSArray()
    var leaveArr = NSArray()
    var sessionArr = NSArray()
    
    var managerMutableArr = NSMutableArray()
    var leaveMutableArr = NSMutableArray()
    var sessionMutableArr = NSMutableArray()
    
    var managerEmail = String()
    var ccMnagerEmail = String()
    
    var leavedays : LeaveDays?
    
    var statusCode = Int()
    
    var fromRefresh = String()
    
    var sessionDaysShort : String?
    var startDaysShort : String?
    var typeDaysShort : String?
    var timeStartshortDays : String?
    
    /*new location code*/
    var locationServicesCheck = true
    var secondCheck = true
    /*new location is upto here*/
    
    //audio code
    var audioPlayer: AVAudioPlayer?
    var retainSelf: WfhVC?
    
    private let locationManager = CLLocationManager()
    
    private lazy var datePicker: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
      datePicker.datePickerMode = .date
       // datePicker.maximumDate = Date()
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
    
    
    @IBOutlet weak var reasonTxtView: AnimatableTextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getDropdownDataShort()
        
        sessionOneBtn.isUserInteractionEnabled = false
        ccTypeBtn.isUserInteractionEnabled = false
        
        /*new location code*/
        //NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        retainSelf = self
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.distanceFilter = 15
//            locationManager.startUpdatingLocation() // Request permission when the app is in use
//        } else {
//                            // Handle the case where location services are not enabled
//            
//            print("Location services are not enabled")
//            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
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
//            
//        }
        /*new location is upto here*/
        
        fromDateTxtFld.text = Date.getCurrentDateChangeNew()
      //  toDateTxtFld.text = Date.getCurrentDateChange()
        
        fromDateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedFrom))
        newFromDateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedFrom))
        
        fromDateTxtFld.tintColor = .clear
        newFromDateTxtFld.tintColor = .clear
        
        newFromDateTxtFld.inputView = datePicker
        fromDateTxtFld.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
       // toDateTxtFld.inputView = datePickerToDate
       // datePickerToDate.addTarget(self, action: #selector(handleDatePickerToDate(sender:)), for: .valueChanged)
        
        reasonTxtView.clipsToBounds = true
        reasonTxtView.layer.shadowOpacity = 0.3
        reasonTxtView.layer.shadowOffset = CGSizeMake(3, 3)
        reasonTxtView.layer.shadowColor = UIColor.lightGray.cgColor
        
        //getDropdownData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: WfhVC.self,
            AnalyticsParameterScreenClass: WfhVC.self])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       // ActivityLoader.shared.hideLoader()
        
        datePicker.date = Date()
        datePickerToDate.date = Date()
        
        fromDateTxtFld.text = Date.getCurrentDateChangeNew()
        fromSessionLbl.text = "Session 1"
        ccLbl.text = "Select Manager"
        reasonTxtView.text = ""
    }
    
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
    /*new location is upto here*/
    
    
    
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
//               UserDefaults.standard.set(placeMarkers.country ?? "", forKey: "CountryName")
//               
//               //self.countryName  = "\(placeMarkers.country!)"
//              // print(self.countryName)
//               
//               /*new location code*/
//               if self.secondCheck == true{
//                   self.getDropdownDataShort()
//                   self.secondCheck = false
//               }else{
//                   
//               }
//               /*new location code is upto here*/
//               //self.getDropdownDataShort()
//               
//             //  self.delegate?.locationData(locationTxt: location, lat: latString, long: longString, titleTxt: "Other")
//               
//              // self.navigationController?.popViewController(animated: true)
//            
//                //self.country = placeMarkers.country!
//              //  print(self.country)
//               
//           }
//       })
//   }
//   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//       print("Error \(error)")
//
//
//       let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
//            //Redirect to Settings app
//            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//        })
//
//       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
//
//           let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainVC") as! HomeMainVC
//           self.navigationController?.pushViewController(secondViewController, animated: false)
//
//       }
//        alertController.addAction(cancelAction)
//
//        alertController.addAction(okAction)
//
//        self.present(alertController, animated: true, completion: nil)
//
//
//   }
   
//   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//       switch status {
//   
//           case .authorizedWhenInUse, .authorizedAlways: break
//                   // Permission granted, you can start using location services
//               case .denied, .restricted:
//                   // Permission denied or restricted, show an alert to guide the user to settings
//                   showLocationPermissionAlert()
//               case .notDetermined: break
//                   // Permission not determined yet
//               @unknown default:
//                   break
//               }
//       
//       
////       if !CLLocationManager.locationServicesEnabled() {
////           //showAlert(msg: "Invalid Permission")
////           showMessage("Invalid Permission")
////      }
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
        
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: WfhVC.self])
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        
        Analytics.logEvent("cancel_action_ios", parameters: [AnalyticsParameterScreenName: ApplyRequestVC.self])
        
        self.tabBarController?.selectedIndex = 0
    }
    
    
    func sendApi(){
        
        if validateSignUpDetails() { // Check Validation

            let type = grantTyleLbl.text!
            let startdate = String(describing: fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
          //  let todate = String(describing: toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
           // let newToDate = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            //print(formattedDate)
            let timeStartDate = "\(newStartDate)\(formattedDate)"
    
            let startsession = fromSessionLbl.text!
           // let endsession = toSessionLbl.text!
            let applyingto = applyingToLbl.text!
           // let worklocation = workLocationTxtFld.text!
            let ccTxt = ccLbl.text!
            let ramarks = reasonTxtView.text!
            

            // Call Apply Leave Api
            applyLeaveCall(type: type, startdate: timeStartDate, sessionstart: startsession, applyto: applyingto, manageremail: self.managerEmail, remarks: ramarks, group: nil)

        }
        
    }
    
    @IBAction func applyAction(_ sender: Any) {
        
        Analytics.logEvent("apply_action_ios", parameters: [AnalyticsParameterScreenName: ApplyRequestVC.self])
        
        sendApi()
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
             
            if self!.fromDateTxtFld.text != ""{
                
                self!.typeDaysShort = self!.grantTyleLbl.text!
                
                let startdate = String(describing: self!.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
              //  let todate = String(describing: toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                
                self!.sessionDaysShort = self!.fromSessionLbl.text!
              //  let endsession = toSessionLbl.text!
                
                self!.startDaysShort = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let currentDate = Date()
                let formattedDate = dateFormatter.string(from: currentDate)
                //print(formattedDate)
                self!.timeStartshortDays = "\(self!.startDaysShort ?? "")\(formattedDate)"
                
                self!.getLeaveDaysCall(type: self!.typeDaysShort ?? "", startdate: self!.timeStartshortDays ?? "", sessionstart: self!.sessionDaysShort ?? "", isovertime: false, group: nil)
                
                
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
            
            self!.ccMnagerEmail = dict.value(forKeyPath: "Value") as? String ?? ""
             
           // self!.type = dict.value(forKeyPath: "Text") as? String ?? ""
            
            //self!.setIsMyRequests(isMyRequest: true, leaveType: self!.type, leaveStatus: self!.status, leaveFrom: self!.fromdate)
            
                
        }
    }
    
    @objc func doneButtonClickedFrom(_ sender: Any) {
        
        if fromDateTxtFld.text != ""{
            
            self.typeDaysShort = grantTyleLbl.text!
            
            let startdate = String(describing: fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
          //  let todate = String(describing: toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            self.sessionDaysShort = fromSessionLbl.text!
          //  let endsession = toSessionLbl.text!
            
            self.startDaysShort = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            //print(formattedDate)
            self.timeStartshortDays = "\(self.startDaysShort ?? "")\(formattedDate)"
            
            getLeaveDaysCall(type: self.typeDaysShort ?? "", startdate: self.timeStartshortDays ?? "", sessionstart: self.sessionDaysShort ?? "", isovertime: false, group: nil)
            
            
        }
        
    }
    
    @objc func doneButtonClickedTo(_ sender: Any) {
        if fromDateTxtFld.text != "" && toDateTxtFld.text != ""{
            
            let type = grantTyleLbl.text!
            
            let startdate = String(describing: fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let todate = String(describing: toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let startsession = fromSessionLbl.text!
            let endsession = toSessionLbl.text!
            
            let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
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
            let timeToDate = "\(todate)\(formattedDateTo)"
            
        //    getLeaveDaysCall(type: type, startdate: timeStartDate, enddate: timeToDate, sessionstart: startsession, sessionend: endsession, isovertime: false, group: nil)
            
            
        }
        
    }
    
    //================================
            //MARK: - Validation Fields
    //================================
            func validateSignUpDetails () -> Bool {

                if fromDateTxtFld.text?.trimmingCharacters(in: .whitespaces).count == 0 {

                    // Show Alert
                    self.showMessage("Please enter Start Date")
                   // emailTxtFld.resignFirstResponder()
                    return false

                }

                return true
            }

}


extension WfhVC{
    
    
    //================================
    //MARK: - Api's Response
    //================================
    //    MARK: - Call Country Listing APi
    
    func getDropdownDataShort() {
        
        // Show Loder
       // loader.addLoader(view: self.view)
        self.showIndicator(withTitle: "Loading...")
        
       // ActivityLoader.shared.showLoaderCentered()
        
        // Get AutorizationToken
        // let AutorizationToken = UserDefaults.standard.string(forKey: "UserAuthorisationToken") ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
        ]
        
        AF.request("\(APIConstants.Collective.authBaseURL)ApplyRequest/GetLeaveFilter", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { [self] response in
            
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
                 //   ActivityLoader.shared.hideLoader()
                    
                    self.sessionOneBtn.isUserInteractionEnabled = true
                    self.ccTypeBtn.isUserInteractionEnabled = true
                    
                    let data = json.value(forKey: "Data") as? NSDictionary ?? [:]
                    
                    self.managerListArr = data.value(forKeyPath: "ManagerList") as? NSArray ?? []
                    //self.leaveArr = data.value(forKeyPath: "LeaveList") as? NSArray ?? []
                    self.sessionArr = data.value(forKeyPath: "SessionList") as? NSArray ?? []
                    
                    let applyingTo = data.value(forKeyPath: "ApplyingTo") as? String ?? ""
                    self.managerEmail = data.value(forKeyPath: "ManagerEmail") as? String ?? ""
                    
                    self.applyingToLbl.text = applyingTo
                    
                    let balance = data.value(forKeyPath: "ShortLeaveBalance") as? String ?? ""
                    self.balanceLbl.text = balance

                    
                }
                
                else if status == 401{
                    self.fromRefresh = "Filter"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    // Hide Loader
                    //self.loader.removeLoader(view: self.view)
                    //self.hideIndicator()
                    //self.showAlert(msg: message)
                    ActivityLoader.shared.hideLoader()
                }
            }
            else {
                // Hide Loader
               // self.loader.removeLoader(view: self.view)
               // self.hideIndicator()
                ActivityLoader.shared.hideLoader()
                
            }
            
        }
    }
    
    
    func applyLeaveCall(type:String, startdate:String, sessionstart: String, applyto: String, manageremail: String, remarks: String, group: DispatchGroup?){
       
        let viewModel = ApplyRequestViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                 //   ActivityLoader.shared.showLoaderCentered()
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
        viewModel.endDate = startdate
        viewModel.startSession = sessionstart
        viewModel.endSession = sessionstart
      //  viewModel.workLocation = worklocation
        viewModel.applyingTo = applyto
        viewModel.managerEmail = manageremail
        viewModel.ccmanagerEmail = self.ccMnagerEmail
        viewModel.remarks = remarks
        viewModel.timezone = AuthUtils.getOfficeLocation()
        viewModel.callApplyLeaveService = true
    }
    
    
    func getLeaveDaysCall(type:String, startdate:String, sessionstart: String, isovertime: Bool, group: DispatchGroup?){
       
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
                    
                    self.fromRefresh = "Leave Days"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    self.leavedays = viewModel.leaveDays
                    
                    self.daysLbl.text = "\(self.leavedays?.Days ?? "")"
                }
                
                group?.leave()

            }

        }
        viewModel.leaveType = type
        viewModel.startDate = startdate
        viewModel.endDate = startdate
        viewModel.startSession = sessionstart
        viewModel.endSession = sessionstart
        viewModel.isOvertime = isovertime
        viewModel.timezone = UserDefaults.standard.string(forKey: "CountryName")
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
                   // ActivityLoader.shared.showLoaderCentered()
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
                        self.getDropdownDataShort()
                    }
                    else if self.fromRefresh == "Apply"{
                        self.sendApi()
                    }
                    else if self.fromRefresh == "Leave Days"{
                        self.getLeaveDaysCall(type: self.typeDaysShort ?? "", startdate: self.timeStartshortDays ?? "", sessionstart: self.sessionDaysShort ?? "", isovertime: false, group: nil)
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

extension WfhVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Release the audio player once it's done playing
        audioPlayer = nil
        
        retainSelf = nil
    }
}
