//
//  EmployeeWFHVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 02/11/23.
//

import UIKit
import IBAnimatable
import CoreLocation
import Alamofire
import FirebaseAnalytics

class EmployeeWFHVC: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var toNewTxtFld: UITextField!
    @IBOutlet weak var fromNewTxtFld: UITextField!
    @IBOutlet weak var toDateTxtFld: AnimatableTextField!
    @IBOutlet weak var fromDateTxtFld: AnimatableTextField!
    @IBOutlet weak var ccManagerNameLbl: UILabel!
    @IBOutlet weak var reasonTxtView: AnimatableTextView!
    @IBOutlet weak var applyingForLbl: UILabel!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var sessionFromLbl: UILabel!
    @IBOutlet weak var sessionToLbl: UILabel!
    @IBOutlet var empActionBtn: UIButton!
    
    var managerListArr = NSArray()
    var sessionArr = NSArray()
    var employeesArr = NSArray()
    
    var managerMutableArr = NSMutableArray()
    var sessionMutableArr = NSMutableArray()
    var employeesMutableArr = NSMutableArray()
    
    private let locationManager = CLLocationManager()
    
    var TypeFordays : String?
    var sessioFromFordays : String?
    var sessionToFordays : String?
    var startDateFordays : String?
    var endDateFordays : String?
    var timeStartDateForDays : String?
    var timeToDateForDays : String?
    
    var statusCode = Int()
    
    var fromRefresh = String()
    
    var leavedays : LeaveDays?
    
    var empId : Int?
    
    var managerEmail = String()
    var ccMnagerEmail = String()
    
    var applyingemail = String()
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 15
            locationManager.startUpdatingLocation() // Request permission when the app is in use
        } else {
                            // Handle the case where location services are not enabled
        }
        
        fromDateTxtFld.text = Date.getCurrentDateChangeNew()
        toDateTxtFld.text = Date.getCurrentDateChangeNew()
        
        fromDateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedFrom))
        toDateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedTo))
        
        fromNewTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedFrom))
        toNewTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedTo))
        
        fromDateTxtFld.tintColor = .clear
        toDateTxtFld.tintColor = .clear
        
        fromNewTxtFld.tintColor = .clear
        toNewTxtFld.tintColor = .clear
        
        fromNewTxtFld.inputView = datePicker
        fromDateTxtFld.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        
       // datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        toNewTxtFld.inputView = datePickerToDate
        toDateTxtFld.inputView = datePickerToDate
        datePickerToDate.addTarget(self, action: #selector(handleDatePickerToDate(sender:)), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: EmployeeWFHVC.self,
            AnalyticsParameterScreenClass: EmployeeWFHVC.self])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.date = Date()
        datePickerToDate.date = Date()
    }
    
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        let manager = CLLocationManager()

        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                    break
            }
        } else {
            hasPermission = false
        }

        return hasPermission
    }
    
    
    //================================
       //MARK: - location delegate methods
   //================================
    
    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error \(error)")
//
//
//        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
//
//         let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
//             //Redirect to Settings app
//             UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//         })
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
//
//            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainVC") as! HomeMainVC
//            self.navigationController?.pushViewController(secondViewController, animated: false)
//
//        }
//         alertController.addAction(cancelAction)
//
//         alertController.addAction(okAction)
//
//         self.present(alertController, animated: true, completion: nil)
//
//
//    }
//
    
    
    // Function to show an alert for location permission
            func showLocationPermissionAlert() {
                let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
     
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
     
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    // Handle cancellation if needed
                }
     
                alertController.addAction(settingsAction)
                alertController.addAction(cancelAction)
     
                self.present(alertController, animated: true, completion: nil)
            }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
    
            case .authorizedWhenInUse, .authorizedAlways: break
                    // Permission granted, you can start using location services
                case .denied, .restricted:
                    // Permission denied or restricted, show an alert to guide the user to settings
                    showLocationPermissionAlert()
                case .notDetermined: break
                    // Permission not determined yet
                @unknown default:
                    break
                }
        
        
//        if status == .authorizedWhenInUse {
//             locationManager.requestLocation()
//         }
        
 //       if !CLLocationManager.locationServicesEnabled() {
 //           //showAlert(msg: "Invalid Permission")
 //           showMessage("Invalid Permission")
 //      }
    }
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        // Show Loder
      //  loader.addLoader(view: self.view)
       
       let User_Location = CLLocation(latitude: manager.location?.coordinate.latitude ?? 0.0, longitude: manager.location?.coordinate.longitude ?? 0.0)
        self.reverseGeocodeCoordinate(coordinate: User_Location)
       self.locationManager.stopUpdatingLocation()
   }
    
    
    
   func reverseGeocodeCoordinate(coordinate: CLLocation) {
       let geocoder = CLGeocoder()
       geocoder.reverseGeocodeLocation(coordinate, completionHandler: {
           placemarks, error in
           if (error != nil) {
               print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
               return
           }
           if (placemarks?.count)! > 0 {
               
               let placeMarkers = placemarks![0]
               
              // var locationLatitude = Double()
              // var locationLongitutude = Double()
               
              // locationLatitude = Double((placeMarkers.location?.coordinate.latitude)!)
              // locationLongitutude = Double((placeMarkers.location?.coordinate.longitude)!)
               
              // let latString = String(locationLatitude)
              // let longString = String(locationLongitutude)
              // UserDefaults.standard.set(latString, forKey: "userselctAddressLat")
              // UserDefaults.standard.set(laongString, forKey: "userselctAddressLong")
               
                // Hide Loader
              //  self.loader.removeLoader(view: self.view)
                // self.isfirstTime = true
               // let location  = "\(placeMarkers.name!),\(placeMarkers.country!)"
               //print(location)
               
               UserDefaults.standard.set(placeMarkers.country ?? "", forKey: "CountryName")
               
               //self.countryName  = "\(placeMarkers.country!)"
              // print(self.countryName)
               
               self.getDropdownData()
               
             //  self.delegate?.locationData(locationTxt: location, lat: latString, long: longString, titleTxt: "Other")
               
              // self.navigationController?.popViewController(animated: true)
            
                //self.country = placeMarkers.country!
              //  print(self.country)
               
           }
       })
   }
    
    
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
    
    
    
    @objc func doneButtonClickedFrom(_ sender: Any) {
        
        if fromDateTxtFld.text != "" && toDateTxtFld.text != ""{
            
           // self.TypeFordays = self.grantTyleLbl.text!
            
            let startdate = String(describing: self.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let todate = String(describing: self.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            self.sessioFromFordays = self.sessionFromLbl.text!
            self.sessionToFordays = self.sessionToLbl.text!
            
            self.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            self.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            //print(formattedDate)
            self.timeStartDateForDays = "\(self.startDateFordays ?? "")\(formattedDate)"
            
            let dateFormatterTo = DateFormatter()
            dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
            let currentDateTo = Date()
            let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
            //print(formattedDate)
            self.timeToDateForDays = "\(self.endDateFordays ?? "")\(formattedDateTo)"
            
            self.getLeaveDaysCall(type: "WFH", startdate: self.timeStartDateForDays ?? "", enddate: self.timeToDateForDays ?? "", sessionstart: self.sessioFromFordays ?? "", sessionend: self.sessionToFordays ?? "", isovertime: false, group: nil)
            
            
        }
        
    }
    
    @objc func doneButtonClickedTo(_ sender: Any) {
        if fromDateTxtFld.text != "" && toDateTxtFld.text != ""{
            
         //   self.TypeFordays = self.grantTyleLbl.text!
            
            let startdate = String(describing: self.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let todate = String(describing: self.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            self.sessioFromFordays = self.sessionFromLbl.text!
            self.sessionToFordays = self.sessionToLbl.text!
            
            
            self.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            self.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            //print(formattedDate)
            self.timeStartDateForDays = "\(self.startDateFordays ?? "")\(formattedDate)"
            
            let dateFormatterTo = DateFormatter()
            dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
            let currentDateTo = Date()
            let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
            //print(formattedDate)
            self.timeToDateForDays = "\(self.endDateFordays ?? "")\(formattedDateTo)"
            
            self.getLeaveDaysCall(type: "WFH", startdate: self.timeStartDateForDays ?? "", enddate: self.timeToDateForDays ?? "", sessionstart: self.sessioFromFordays ?? "", sessionend: self.sessionToFordays ?? "", isovertime: false, group: nil)
            
            
        }
        
    }
    
    @IBAction func selectEmpAction(_ sender: Any) {
        
        if employeesArr.count == 0{
            
            self.showMessage("Error", "You don't have any employee.")
            
        }else{
            
            employeesMutableArr.removeAllObjects()
            
            for index in 0...self.employeesArr.count-1 {
                
                let dict = employeesArr[index] as? NSDictionary ?? [:]
                
                let title = dict.value(forKeyPath: "tm_employee_name") as? String ?? ""
                // partId = dict.value(forKeyPath: "id") as? Int ?? 0
                self.employeesMutableArr.add(String(title))
            }
            
            RPicker.selectOption(dataArray: (employeesMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                
                // TODO: Your implementation for selection
                
                let dict = self!.employeesArr[atIndex] as? NSDictionary ?? [:]
                
                self?.empId = dict.value(forKeyPath: "tm_employeeid") as? Int ?? 0
                
                self!.empNameLbl.text = dict.value(forKeyPath: "tm_employee_name") as? String ?? ""
                
                self?.applyingemail = dict.value(forKeyPath: "tm_employeeemail") as? String ?? ""
                
                // self!.type = dict.value(forKeyPath: "Text") as? String ?? ""
                
                // self!.ccMnagerEmail = dict.value(forKeyPath: "Value") as? String ?? ""
                
                //self!.setIsMyRequests(isMyRequest: true, leaveType: self!.type, leaveStatus: self!.status, leaveFrom: self!.fromdate)
                
                
            }
        }
        
        
    }
    
    @IBAction func sessionToAction(_ sender: Any) {

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
            
            self!.sessionToLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
            
            
            if self!.fromDateTxtFld.text != "" && self!.toDateTxtFld.text != ""{
                
              //  self!.TypeFordays = self!.grantTyleLbl.text!
                
                let startdate = String(describing: self!.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                let todate = String(describing: self!.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                
                self!.sessioFromFordays = self!.sessionFromLbl.text!
                self!.sessionToFordays = self!.sessionToLbl.text!
                
                
                self!.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                self!.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
                let currentDate = Date()
                let formattedDate = dateFormatter.string(from: currentDate)
                //print(formattedDate)
                self!.timeStartDateForDays = "\(self!.startDateFordays ?? "")\(formattedDate)"
                
                let dateFormatterTo = DateFormatter()
                dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
                let currentDateTo = Date()
                let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
                //print(formattedDate)
                self!.timeToDateForDays = "\(self!.endDateFordays ?? "")\(formattedDateTo)"
                
                self!.getLeaveDaysCall(type: "WFH", startdate: self!.timeStartDateForDays ?? "", enddate: self!.timeToDateForDays ?? "", sessionstart: self!.sessioFromFordays ?? "", sessionend: self!.sessionToFordays ?? "", isovertime: false, group: nil)
                
                
            }
            
            
        }
       

    }
        

    @IBAction func sessionFromAction(_ sender: Any) {
        
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
            
            self!.sessionFromLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
             
            if self!.fromDateTxtFld.text != "" && self!.toDateTxtFld.text != ""{
                
              //  self!.TypeFordays = self!.grantTyleLbl.text!
                
                let startdate = String(describing: self!.fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                let todate = String(describing: self!.toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                
                self!.sessioFromFordays = self!.sessionFromLbl.text!
                self!.sessionToFordays = self!.sessionToLbl.text!
                
                
                self!.startDateFordays = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                self!.endDateFordays = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
                let currentDate = Date()
                let formattedDate = dateFormatter.string(from: currentDate)
                //print(formattedDate)
               // self!.timeStartDateForDays = "\(self!.startDateFordays ?? "")\(formattedDate)"
                
                let dateFormatterTo = DateFormatter()
                dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
                //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
                let currentDateTo = Date()
                let formattedDateTo = dateFormatterTo.string(from: currentDateTo)
                //print(formattedDate)
                self!.timeToDateForDays = "\(self!.endDateFordays ?? "")\(formattedDateTo)"
                
                self!.getLeaveDaysCall(type: "WFH", startdate: self!.timeStartDateForDays ?? "", enddate: self!.timeToDateForDays ?? "", sessionstart: self!.sessioFromFordays ?? "", sessionend: self!.sessionToFordays ?? "", isovertime: false, group: nil)
                
                
            }
            
                
        }
        
        
    }
    
    @IBAction func selectCCAction(_ sender: Any) {
        
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
            
            self!.ccManagerNameLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
             
           // self!.type = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.ccMnagerEmail = dict.value(forKeyPath: "Value") as? String ?? ""
            
            //self!.setIsMyRequests(isMyRequest: true, leaveType: self!.type, leaveStatus: self!.status, leaveFrom: self!.fromdate)
            
                
        }
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: EmployeeWFHVC.self])
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        Analytics.logEvent("cancel_action_ios", parameters: [AnalyticsParameterScreenName: EmployeeWFHVC.self])
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func applyAction(_ sender: Any) {
        Analytics.logEvent("apply_action_ios", parameters: [AnalyticsParameterScreenName: EmployeeWFHVC.self])
        sendApi()
    }
    
    
    
    func sendApi(){
        
        if validateSignUpDetails() { // Check Validation

            let startdate = String(describing: fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let todate = String(describing: toDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            let newToDate = todate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
            let currentDate = Date()
            let formattedDate = dateFormatter.string(from: currentDate)
            //print(formattedDate)
            let timeStartDate = "\(newStartDate)\(formattedDate)"
            
            let dateFormatterTo = DateFormatter()
            dateFormatterTo.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
            let currentDateTo = Date()
            let formattedDateTo = dateFormatterTo.string(from: currentDate)
            //print(formattedDate)
            let timeToDate = "\(newToDate)\(formattedDateTo)"
            
            
            let startsession = sessionFromLbl.text!
            let endsession = sessionToLbl.text!
            let applyingto = self.empNameLbl.text ?? ""
          //  let ccTxt = ccLbl.text!
            let ramarks = reasonTxtView.text!
            
            // Call Apply Leave Api
            //applyWFHCall(type: "WFH", startdate: timeStartDate, enddate: timeToDate, sessionstart: startsession, sessionend: endsession, applyto: applyingto, manageremail: self.managerEmail, remarks: ramarks, group: nil)
            
            applyWFHCall(type: "WFH", startdate: timeStartDate, enddate: timeToDate, sessionstart: startsession, sessionend: endsession, applyto: self.applyingemail, manageremail: self.managerEmail, remarks: ramarks, applyingName: applyingto, applyingid: self.empId ?? 0, group: nil)
           

        }
    }
    
    
    //================================
            //MARK: - Validation Fields
    //================================
            func validateSignUpDetails () -> Bool {

                if empNameLbl.text == "Select Employee Name"{
                    // Show Alert
                    self.showMessage("Please select Employee Name")
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
                    
                return true
            }
    
}

extension EmployeeWFHVC{
    
    
    //================================
    //MARK: - Api's Response
    //================================
    //    MARK: - Call DropDown Data APi
    
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
                    self.sessionArr = data.value(forKeyPath: "SessionList") as? NSArray ?? []
                    
                    self.managerEmail = data.value(forKeyPath: "ManagerEmail") as? String ?? ""
                    
                    self.getEmployeesData()
                   
                }
                else if status == 401{
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
    
    
    func getEmployeesData() {
        
        // Show Loder
        // loader.addLoader(view: self.view)
        self.showIndicator(withTitle: "Loading...")
        // ActivityLoader.shared.showLoaderCentered()
        
        // Get AutorizationToken
        // let AutorizationToken = UserDefaults.standard.string(forKey: "UserAuthorisationToken") ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
        ]
        
        AF.request("\(APIConstants.Collective.authBaseURL)ApplyRequest/GetResourceList", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
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
                    
                   // let data = json.value(forKey: "Data") as? NSDictionary ?? [:]
                    
                    self.employeesArr = json.value(forKeyPath: "Data") as? NSArray ?? []
                    
                   
                }
                else if status == 401{
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
    
    
    
    func getLeaveDaysCall(type:String, startdate:String, enddate: String, sessionstart: String, sessionend: String, isovertime: Bool, group: DispatchGroup?){
       
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
                    
                   // self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    self.leavedays = viewModel.leaveDays
                    
                    if self.leavedays?.Days == nil{
                        self.applyingForLbl.text = "0"
                    }
                    else{
                        self.applyingForLbl.text = "\(self.leavedays?.Days ?? "")"
                    }
                    
                    
//                    if self.grantTyleLbl.text == "WFH"{
//
//                    }
//                    else{
//                        if let balance = Double(self.balanceLbl.text ?? ""), let days = Double(self.daysLbl.text ?? "") {
//                            if balance < days {
//                                self.showMessage("You don't have enough balance")
//                            }
//                        }
//                    }
                 
                    
                }
                
                group?.leave()

            }

        }
        viewModel.applyingId = self.empId
        viewModel.leaveType = type
        viewModel.startDate = startdate
        viewModel.endDate = enddate
        viewModel.startSession = sessionstart
        viewModel.endSession = sessionend
        viewModel.isOvertime = isovertime
        viewModel.timezone = UserDefaults.standard.string(forKey: "CountryName")
        viewModel.callGetManagerLeaveDaysService = true
    }
    
    
    
    func applyWFHCall(type:String, startdate:String, enddate: String, sessionstart: String, sessionend: String, applyto: String, manageremail: String, remarks: String, applyingName: String, applyingid: Int, group: DispatchGroup?){
       
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
        viewModel.applyingEmail = applyto
        viewModel.applyingId = applyingid
        viewModel.applyingName = applyingName
        viewModel.managerEmail = AuthUtils.getEmail()
        viewModel.ccmanagerEmail = self.ccMnagerEmail
        viewModel.remarks = remarks
        viewModel.timezone = UserDefaults.standard.string(forKey: "CountryName")
        viewModel.callManagerApplyWFHService = true
    }
    
    
}
