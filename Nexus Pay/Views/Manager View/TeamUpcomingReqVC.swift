//
//  TeamUpcomingReqVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 08/06/23.
//

import UIKit
import IBAnimatable
import Alamofire
import FirebaseAnalytics
import SwiftGifOrigin

class TeamUpcomingReqVC: UIViewController, DataEnteredDelegate {
    
    @IBOutlet weak var newFromDateTxtFld: UITextField!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var upcomingReqTblView: UITableView!
    @IBOutlet weak var dateTxtFld: AnimatableTextField!
    @IBOutlet weak var resourcesLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    
    @IBOutlet var clearFilterBtn: AnimatableButton!
    
    var loader = Loader()
    
    var typeArr = NSArray()
    var statusArr = NSArray()
    var resourcesArr = NSArray()
    
    var typeMutableArr = NSMutableArray()
    var statusMutableArr = NSMutableArray()
    var resourcesMutableArr = NSMutableArray()
    
    var upcomingLeaveSummaryListingArray : [managerSummaryList]?
    
    var type = String()
    var Status = String()
    var empid = String()
    var fromdate = String()
    
    var statusCode = Int()
    var fromRefresh = String()
    
    var gifImageView: UIImageView! //gifOutlet
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBack(_:)))
        swipeRight.edges = .left
        view.addGestureRecognizer(swipeRight)
        
        let view = UIView()
        upcomingReqTblView.tableFooterView = view
        
        upcomingReqTblView.register(UpcomingReqTVC.loadNib(), forCellReuseIdentifier: "UpcomingReqTVC")
        
        dateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedFrom))
        newFromDateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClickedFrom))
        
        dateTxtFld.tintColor = .clear
        newFromDateTxtFld.tintColor = .clear
        
        newFromDateTxtFld.inputView = datePicker
        dateTxtFld.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        getCountryData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: TeamUpcomingReqVC.self,
            AnalyticsParameterScreenClass: TeamUpcomingReqVC.self])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.date = Date()
    }
    
    func showGif() {
            // Create an instance of UIImageView with a GIF
        
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = false
        
            guard let gifURL = Bundle.main.url(forResource: "team-request11", withExtension: "gif"),
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
                    gifImageView.topAnchor.constraint(equalTo: clearFilterBtn.bottomAnchor), // Adjust the constant as needed
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
    
    func BackToPreviousReq(info: String) {
        self.setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.Status, leaveFrom: self.fromdate, empid: self.empid)
    }
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd/MM/yyyy"
        dateTxtFld.text = dateFormatter.string(from: sender.date)
        
     }
    
    func setIsMyRequests(isMyRequest:Bool, leaveType: String, leaveStatus: String, leaveFrom: String, empid: String){
        self.upcomingLeaveSummaryListingArray?.removeAll()
        self.refreshRequestTableView(checkNoRecords: false)
        managerUpcomingLeaveSummaryCall(type: leaveType, status: leaveStatus, fromDate: leaveFrom, empid: empid, group: nil)
        
    }
    
    func showNoRecordsLabel(show:Bool){
        self.noDataLbl.isHidden = !show
    }
    
    func refreshRequestTableView(checkNoRecords:Bool){
        self.upcomingReqTblView.reloadData()
        if checkNoRecords == true{
            if self.upcomingLeaveSummaryListingArray?.count == 0 {
                self.showNoRecordsLabel(show: true)
                self.upcomingReqTblView.isHidden = true
                
            }else{
                self.showNoRecordsLabel(show: false)
                self.upcomingReqTblView.isHidden = false
                
            }
        }
    }
    
    
    @objc func doneButtonClickedFrom(_ sender: Any) {
        
        if dateTxtFld.text == ""{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY" // Customize the date format as per your requirements

            dateTxtFld.text = dateFormatter.string(from: Date())
            
            let startdate = String(describing: dateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
//            let currentDate = Date()
//            let formattedDate = dateFormatter1.string(from: currentDate)
            //print(formattedDate)
            // self.fromdate = "\(newStartDate)\(formattedDate)"
            self.fromdate = newStartDate
            
            setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.Status, leaveFrom: self.fromdate, empid: self.empid)
            
        }
        
        if dateTxtFld.text != ""{
            
            let startdate = String(describing: dateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "'T'HH:mm:ss.SSS'Z'"
            //dateFormatter.timeZone = TimeZone(abbreviation: "IST")
//            let currentDate = Date()
//            let formattedDate = dateFormatter.string(from: currentDate)
            //print(formattedDate)
           // self.fromdate = "\(newStartDate)\(formattedDate)"
            self.fromdate = newStartDate
            
            setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.Status, leaveFrom: self.fromdate, empid: self.empid)
            
        }
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: TeamUpcomingReqVC.self])
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func clearFilterAction(_ sender: Any) {
        
        Analytics.logEvent("clearFilter_action_ios", parameters: [AnalyticsParameterScreenName: TeamUpcomingReqVC.self])
        
        dateTxtFld.text = ""
        statusLbl.text = "All"
        resourcesLbl.text = "All Resources"
        typeLbl.text = "All"
        
        setIsMyRequests(isMyRequest: true, leaveType: "", leaveStatus: "", leaveFrom: "", empid: "")
    }
    
    
    @IBAction func typeDropdownAction(_ sender: Any) {
        typeMutableArr.removeAllObjects()
        
        for index in 0...self.typeArr.count-1 {
            
            let dict = typeArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.typeMutableArr.add(String(title))
        }

        RPicker.selectOption(dataArray: (typeMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.typeArr[atIndex] as? NSDictionary ?? [:]
            
           // self?.countryId = dict.value(forKeyPath: "id") as? Int ?? 0
            
            self!.typeLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
             
            self!.type = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.setIsMyRequests(isMyRequest: true, leaveType: self!.type, leaveStatus: self!.Status, leaveFrom: self!.fromdate, empid: self!.empid)
            
                
        }
    }
    
    
    @IBAction func statusDropdownAction(_ sender: Any) {
        statusMutableArr.removeAllObjects()
        
        for index in 0...self.statusArr.count-1 {
            
            let dict = statusArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.statusMutableArr.add(String(title))
        }

        RPicker.selectOption(dataArray: (statusMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.statusArr[atIndex] as? NSDictionary ?? [:]
            
           // self?.countryId = dict.value(forKeyPath: "id") as? Int ?? 0
            
            self!.statusLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.Status = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.setIsMyRequests(isMyRequest: true, leaveType: self!.type, leaveStatus: self!.Status, leaveFrom: self!.fromdate, empid: self!.empid)
            
                
        }
    }
    
    
    @IBAction func resourcesDropdownAction(_ sender: Any) {
        resourcesMutableArr.removeAllObjects()
        
        for index in 0...self.resourcesArr.count-1 {
            
            let dict = resourcesArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.resourcesMutableArr.add(String(title))
        }

        RPicker.selectOption(dataArray: (resourcesMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.resourcesArr[atIndex] as? NSDictionary ?? [:]
            
           // self?.countryId = dict.value(forKeyPath: "id") as? Int ?? 0
            
            self!.resourcesLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.empid = dict.value(forKeyPath: "Value") as? String ?? ""
             
            self!.setIsMyRequests(isMyRequest: true, leaveType: self!.type, leaveStatus: self!.Status, leaveFrom: self!.fromdate, empid: self!.empid)
            
                
        }
    }
    
    @objc func tappedStatusButton(_ sender: UIButton) {
        let leaves = self.upcomingLeaveSummaryListingArray![sender.tag]
        let guidId = leaves.Guid ?? ""
        let leaveStatus = leaves.LeaveStatus ?? ""
        let leaveCategory = leaves.LeaveCategory ?? ""
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ManagerLeaveDetailsVC") as! ManagerLeaveDetailsVC
        secondViewController.guid = guidId
      //  secondViewController.status = leaveStatus
      //  secondViewController.leavecategory = leaveCategory
        secondViewController.delegate = self
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    

}

extension TeamUpcomingReqVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.upcomingLeaveSummaryListingArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Categoriescell : UpcomingReqTVC = tableView.dequeueReusableCell(withIdentifier: "UpcomingReqTVC", for: indexPath) as! UpcomingReqTVC
        
       // Categoriescell.menuLbl.text = menusArr[indexPath.row]
        Categoriescell.selectionStyle = .none
        
        if indexPath.row % 2 == 0{
            Categoriescell.mainView.backgroundColor = UIColor.white
        }
        else{
            Categoriescell.mainView.backgroundColor = UIColor.companyHolidays
        }
        
        
        let leaves = self.upcomingLeaveSummaryListingArray![indexPath.row]
        Categoriescell.setUI(leaveBalance: leaves)
        
        Categoriescell.statusBtn.tag = indexPath.row
        Categoriescell.statusBtn.addTarget(self, action: #selector(tappedStatusButton), for: .touchUpInside)
        
        
        return Categoriescell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leaves = self.upcomingLeaveSummaryListingArray![indexPath.row]
        let guidId = leaves.Guid ?? ""
        let leaveStatus = leaves.LeaveStatus ?? ""
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ManagerLeaveDetailsVC") as! ManagerLeaveDetailsVC
        secondViewController.guid = guidId
        secondViewController.status = leaveStatus
        secondViewController.delegate = self
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 48
        
    }
}

extension TeamUpcomingReqVC{
    
    
    //================================
    //MARK: - Api's Response
    //================================
    //    MARK: - Call Country Listing APi
    
    func getCountryData() {
        
        // Show Loder
       
        self.showGif()
       
        
        // Get AutorizationToken
        // let AutorizationToken = UserDefaults.standard.string(forKey: "UserAuthorisationToken") ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
        ]
        
        AF.request("\(APIConstants.Collective.authBaseURL)ApplyRequest/GetManagerTeamUpcomingFilter", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
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
                    //self.hideIndicator()
                    self.hideGif()
                  //  ActivityLoader.shared.hideLoader()
                    
                    let data = json.value(forKey: "Data") as? NSDictionary ?? [:]
                    
                    self.typeArr = data.value(forKeyPath: "LeaveList") as? NSArray ?? []
                    self.statusArr = data.value(forKeyPath: "StatusList") as? NSArray ?? []
                    self.resourcesArr = data.value(forKeyPath: "ResourceList") as? NSArray ?? []
                    
                    self.setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.Status, leaveFrom: self.fromdate, empid: self.empid)
                    
                }
                
                else if status == 401{
                    
                    self.fromRefresh = "Filter"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    // Hide Loader
                    //self.hideIndicator()
                    self.hideGif()
                   
                }
            }
            else {
                // Hide Loader
               
                self.hideGif()
               // ActivityLoader.shared.hideLoader()
                
            }
            
        }
    }
    
    
    func managerUpcomingLeaveSummaryCall(type: String, status: String, fromDate: String, empid: String, group: DispatchGroup?){
       
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
                    
                    self.fromRefresh = "Summary"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    self.upcomingLeaveSummaryListingArray = viewModel.managerSummaryListArr
                  
                    self.refreshRequestTableView(checkNoRecords: true)
                }
    
            }

        }
        viewModel.type = type
        viewModel.status = status
        viewModel.fromDate = fromDate
        viewModel.empId = empid
        viewModel.callGetManagerUpcomingSummaryListingListingService = true
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
                    
                    if self.fromRefresh == "Filter"{
                        self.getCountryData()
                    }
                    else{
                        self.setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.Status, leaveFrom: self.fromdate, empid: self.empid)
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
