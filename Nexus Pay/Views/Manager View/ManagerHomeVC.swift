//
//  ManagerHomeVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 08/06/23.
//

import UIKit
import Alamofire
import IBAnimatable
import FirebaseAnalytics
import SwiftGifOrigin
import AVFoundation

class ManagerHomeVC: UIViewController, DataEnteredDelegate {
    
    @IBOutlet weak var reasonTxtView: AnimatableTextView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet var reasonView: AnimatableView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var leavesTblView: UITableView!
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet var empWfhBtn: UIButton!
    @IBOutlet var empWfhLbl: UILabel!
    @IBOutlet var empWfhView: AnimatableView!
    @IBOutlet var onLeaveView: UIView!
    @IBOutlet var nameTypeView: UIView!
    
    @IBOutlet var empLbl: UILabel!
    var gifImageView: UIImageView! //gifOutlet
    
    @IBOutlet var approveAllBtn: UIButton!
    @IBOutlet var checkBoxBtn: UIButton!
    
    var typeListArr = NSArray()
    
    var typeMutableArr = NSMutableArray()
    
    var employeesArr = NSArray()
    var employeesMutableArr = NSMutableArray()
    
    var loader = Loader()
    
    var managerSummaryListingArray : [managerSummaryList]?
    
    var guidId = String()
    
    var leavetype = "All"
    
    var empid = Int()
    
    var status = ""
    
    var statusCode = Int()
    
    var fromRefresh = String()
    
    var reasonTxtSend = String()
    var statusSend = String()
    
    let refreshControl = UIRefreshControl()
    
    var fromPullRefresh = "Normal"
    
    var approveString = ""
    
    //audio code
    var audioPlayer: AVAudioPlayer?
    var retainSelf: ManagerHomeVC?
                                                                                  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        retainSelf = self
        
        //empWfh functions
        empWfhBtn.isHidden = true
        empWfhLbl.isHidden = true
        empWfhView.isHidden = true
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        //refreshControl.tintColor = .appBlue
        leavesTblView.addSubview(refreshControl)
        
        leavesTblView.register(ManagerHomeTVC.loadNib(), forCellReuseIdentifier: "ManagerHomeTVC")
        
        shadowView.isHidden = true
        
        approveAllBtn.layer.cornerRadius = 12
        
        approveAllBtn.backgroundColor = .lightGray
        approveAllBtn.tintColor = .white
        approveAllBtn.isUserInteractionEnabled = false
        
        getDropdownData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self,
            AnalyticsParameterScreenClass: ManagerHomeVC.self])
    }
    
    func showGif() {
            // Create an instance of UIImageView with a GIF
        
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = false
        
            guard let gifURL = Bundle.main.url(forResource: "managerHomeScreen", withExtension: "gif"),
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
                    gifImageView.topAnchor.constraint(equalTo: nameTypeView.bottomAnchor), // Adjust the constant as needed
                    gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    gifImageView.bottomAnchor.constraint(equalTo: onLeaveView.topAnchor)
                ])
        }
    
    func hideGif() {
        // Hide the UIImageView or remove it from the superview
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = true
        gifImageView.removeFromSuperview()
        // Additional cleanup or actions can be performed here
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        fromPullRefresh = "Pull"
        
        checkBoxBtn.setImage(UIImage(named: "BlankBox"), for: .normal)
        
        
        
        self.setIsMyRequests(isMyRequest: true, type: self.leavetype, employeeId: empid)
    }
    
    func BackToPreviousReq(info: String) {
        self.setIsMyRequests(isMyRequest: true, type: self.leavetype, employeeId: empid)
    }
    
    func setIsMyRequests(isMyRequest:Bool, type: String, employeeId:Int){
        //self.managerSummaryListingArray?.removeAll()
        self.refreshRequestTableView(checkNoRecords: false)
        
        managerSummaryCall(leavetype: type, empID: employeeId, group: nil)
    }
    
    func showNoRecordsLabel(show:Bool){
        self.noDataLbl.isHidden = !show
    }
    
    func refreshRequestTableView(checkNoRecords:Bool){
        self.leavesTblView.reloadData()
        if checkNoRecords == true{
            if self.managerSummaryListingArray?.count == 0 {
                self.showNoRecordsLabel(show: true)
                self.leavesTblView.isHidden = true
                
            }else{
                self.showNoRecordsLabel(show: false)
                self.leavesTblView.isHidden = false
                
            }
        }
    }
    
    
    @IBAction func onLeaveAction(_ sender: Any) {
        
        Analytics.logEvent("onLeave_action_ios", parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self])
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnLeaveVC") as! OnLeaveVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    @IBAction func cancelPopupAction(_ sender: Any) {
        
        Analytics.logEvent("cancerPopup_action_ios", parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self])
        
//        shadowView.isHidden = true
        
        UIView.animate(withDuration: 0.4, animations: {
                // Slide reasonView back down below the screen
                self.reasonView.center.y = self.view.frame.height + self.reasonView.frame.height
            }) { (_) in
                // After animation completes, hide the shadowView
                self.shadowView.isHidden = true
            }
        
        
    }
    
    
    @IBAction func submitPopupAction(_ sender: Any) {
        
        Analytics.logEvent("submit_action_ios", parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self])
        
        if validateSignUpDetails() {
            
            reasonTxtSend = String(describing: reasonTxtView.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            
            if self.status == "Pending"{
                
                statusSend = "Disapproved"
                
                changeLeaveStatusCall(guid: guidId, status: statusSend, reason: reasonTxtSend, group: nil)
            }
            else{
                statusSend = "Rejected"
                changeLeaveStatusCall(guid: guidId, status: statusSend, reason: reasonTxtSend, group: nil)
            }
            
            
        }
        
        
    }
    
    
    @IBAction func empWfhAction(_ sender: Any) {
        
        Analytics.logEvent("empWFH_action_ios", parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self])
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeWFHVC") as! EmployeeWFHVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    @IBAction func dropDownAction(_ sender: Any) {
        
        typeMutableArr.removeAllObjects()
        
        for index in 0...self.typeListArr.count-1 {
            
            let dict = typeListArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.typeMutableArr.add(String(title))
        }
        
        fromPullRefresh = "Normal"

        RPicker.selectOption(dataArray: (typeMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.typeListArr[atIndex] as? NSDictionary ?? [:]
            
           // self?.countryId = dict.value(forKeyPath: "id") as? Int ?? 0
            
            self!.leavetype = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.typeLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.setIsMyRequests(isMyRequest: true, type: self!.leavetype, employeeId: self!.empid)
             
                
        }
    }
    
    
    @IBAction func selectEmpAction(_ sender: Any) {
        
        employeesMutableArr.removeAllObjects()
        
        for index in 0...self.employeesArr.count-1 {
            
            let dict = employeesArr[index] as? NSDictionary ?? [:]
            
            let title = dict.value(forKeyPath: "tm_employee_name") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.employeesMutableArr.add(String(title))
        }
        
        fromPullRefresh = "Normal"

        RPicker.selectOption(dataArray: (employeesMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in
                 
            // TODO: Your implementation for selection
               
            let dict = self!.employeesArr[atIndex] as? NSDictionary ?? [:]
            
           // self?.countryId = dict.value(forKeyPath: "id") as? Int ?? 0
            
            self!.empid = dict.value(forKeyPath: "tm_employeeid") as? Int ?? 0
            
            self!.empLbl.text = dict.value(forKeyPath: "tm_employee_name") as? String ?? ""
            
            self!.setIsMyRequests(isMyRequest: true, type: self!.leavetype, employeeId: self!.empid)
             
                
        }
        
        
    }
    
    //new code for all
    var isAllSelected: Bool = false {
            didSet {
                
                self.leavesTblView.reloadData()
                if isAllSelected {
                    // check image
                    checkBoxBtn.setImage(UIImage(named: "CheckBox"), for: .normal)
                }
                else{
                    // normal image
                    checkBoxBtn.setImage(UIImage(named: "BlankBox"), for: .normal)
                }
            }
        }
    
    
    
    @IBAction func approveAllBtn(_ sender: UIButton) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            
            let ids = (self.managerSummaryListingArray?.filter { $0.isSelected } ?? []).map { $0.Guid ?? "" }
            print(ids)
            
            self.showMessageCustom("Selected Request: \(ids.count)", "Are you sure you want to approve all the selected requests ?", options: ["Approve","Close"], style: .alert) { (index) in
                        if index == 0 {
                            self.changeLeaveStatusCallAll(guid: ids, group: nil)
                          
                        }else{
                            print("no")
                        }
                    }
                }
        
        
//        let ids = (self.managerSummaryListingArray?.filter { $0.isSelected } ?? []).map { $0.Guid ?? "" }
//        print(ids)
//
//        changeLeaveStatusCallAll(guid: ids, group: nil)
       
    }
    
    @IBAction func checkBoxBtn(_ sender: UIButton) {
        
        isAllSelected = !isAllSelected
                for index in 0..<(self.managerSummaryListingArray?.count ?? 0) {
                    self.managerSummaryListingArray?[index].isSelected = isAllSelected
                }
        self.leavesTblView.reloadData()
        
    }
    
    
    @IBAction func teamReqAction(_ sender: Any) {
        
        Analytics.logEvent("teamReq_action_ios", parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self])
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TeamUpcomingReqVC") as! TeamUpcomingReqVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    @IBAction func employeeViewAction(_ sender: Any) {
        
        Analytics.logEvent("empView_action_ios", parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self])
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedOnInfoButton(_ sender: UIButton) {
        
        Analytics.logEvent("info_action_ios", parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self])
        
        let leaves = self.managerSummaryListingArray![sender.tag]
        let guidId = leaves.Guid ?? ""
        let leaveStatus = leaves.LeaveStatus ?? ""
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ManagerLeaveDetailsVC") as! ManagerLeaveDetailsVC
        secondViewController.guid = guidId
       // secondViewController.status = leaveStatus
        secondViewController.delegate = self
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    @objc func tappedOnApproveButton(_ sender: UIButton) {
        
        Analytics.logEvent("approve_action_ios", parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self])
        
        let leaves = self.managerSummaryListingArray![sender.tag]
         guidId = leaves.Guid ?? ""
        //let leaveStatus = leaves.LeaveStatus ?? ""
        
        reasonTxtSend = ""
        statusSend = "Approved"
        
        changeLeaveStatusCall(guid: guidId, status: statusSend, reason: reasonTxtSend, group: nil)
        
        
    }
    
    @objc func tappedCrossButton(_ sender: UIButton) {
        
        Analytics.logEvent("cross_action_ios", parameters: [AnalyticsParameterScreenName: ManagerHomeVC.self])
        
        reasonTxtView.text = ""
        
        let leaves = self.managerSummaryListingArray![sender.tag]
         guidId = leaves.Guid ?? ""
        
        self.status = leaves.LeaveStatus ?? ""
        
        shadowView.isHidden = false
        
        reasonView.frame.origin.y = view.frame.height

        // Show the reasonView with slide-up animation
        UIView.animate(withDuration: 0.4, animations: {
            // Slide reasonView up to the center of the screen
            self.reasonView.center.y = self.view.center.y
        })
        
    }
    
    //new code for all
    @objc func approveSeparatelyBtn(_ sender: UIButton) {
        
        let newValue = !(self.managerSummaryListingArray![sender.tag].isSelected)
                self.managerSummaryListingArray![sender.tag].changeValue(withNewValue: newValue)
                //setSelectedArrayCount()
                self.leavesTblView.reloadData()
                if self.managerSummaryListingArray?.allSatisfy({$0.isSelected}) ?? false {
                    //// check image
                    ///
                    isAllSelected = true
                    checkBoxBtn.setImage(UIImage(named: "CheckBox"), for: .normal)
                } else {
                    isAllSelected = false
                    // // check image
                    
                    checkBoxBtn.setImage(UIImage(named: "BlankBox"), for: .normal)
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

extension ManagerHomeVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.managerSummaryListingArray?.count ?? 0
    }
    
    func updateApproveButtonState() {
        let anySelected = self.managerSummaryListingArray?.contains(where: { $0.isSelected }) ?? false
        if anySelected {
            approveAllBtn.backgroundColor = .appColor
            approveAllBtn.tintColor = .white
            approveAllBtn.isUserInteractionEnabled = true
        } else {
            approveAllBtn.backgroundColor = .lightGray
            approveAllBtn.tintColor = .white
            approveAllBtn.isUserInteractionEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Categoriescell : ManagerHomeTVC = tableView.dequeueReusableCell(withIdentifier: "ManagerHomeTVC", for: indexPath) as! ManagerHomeTVC
        
        Categoriescell.selectionStyle = .none
        
        let leaves = self.managerSummaryListingArray![indexPath.row]
        Categoriescell.setUI(managerSummary: leaves)
        
        
        if indexPath.row % 2 == 0{
            Categoriescell.mainView.backgroundColor = UIColor.companyHolidays
        }
        else{
            Categoriescell.mainView.backgroundColor = UIColor.white
        }
        
        Categoriescell.infoBtn.tag = indexPath.row
        Categoriescell.infoBtn.addTarget(self, action: #selector(tappedOnInfoButton), for: .touchUpInside)
        
        Categoriescell.approveBtn.tag = indexPath.row
        Categoriescell.approveBtn.addTarget(self, action: #selector(tappedOnApproveButton), for: .touchUpInside)
        
        Categoriescell.crossBtn.tag = indexPath.row
        Categoriescell.crossBtn.addTarget(self, action: #selector(tappedCrossButton), for: .touchUpInside)
        
        if let isSelected = self.managerSummaryListingArray?[indexPath.row].isSelected {
            Categoriescell.approveAllBtn.setImage(UIImage(named: isSelected ? "CheckBox" : "BlankBox"), for: .normal)
            Categoriescell.leaveStackView.isUserInteractionEnabled = !isSelected
            Categoriescell.approveBtn.isEnabled = !isSelected
            Categoriescell.infoBtn.isEnabled = !isSelected
            Categoriescell.crossBtn.isEnabled = !isSelected
            
            if approveString == "Success"{
                
                //updateApproveButtonState()
                approveString = ""
            }else{
                updateApproveButtonState()
                //approveString = ""
            }
        }
        
        Categoriescell.approveAllBtn.tag = indexPath.row
        Categoriescell.approveAllBtn.addTarget(self, action: #selector(approveSeparatelyBtn), for: .touchUpInside)
        
        return Categoriescell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
        
    }
}

extension ManagerHomeVC{
    
    
    //================================
    //MARK: - Api's Response
    //================================
    //    MARK: - Call Dropdown Listing APi
    
    func getDropdownData() {
        
        // Show Loder
        self.showGif()
       // ActivityLoader.shared.showLoaderCentered()
        
        // Get AutorizationToken
        // let AutorizationToken = UserDefaults.standard.string(forKey: "UserAuthorisationToken") ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
        ]
        
        AF.request("\(APIConstants.Collective.authBaseURL)ApplyRequest/GetResourceAndLeaveTypeList", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            //   print(response.value!)
            let json = response.value as? [String: Any]
            if json != nil{
                let json : NSDictionary = response.value as? NSDictionary ?? [:]
                print(json)
                let status = json.value(forKey: "StatusCode") as? Int ?? 0
                let message = json.value(forKey: "Message") as? String ?? ""
                if status == 200 {
                    
                    // Hide Loader
                  
                    self.hideGif()
                   // ActivityLoader.shared.hideLoader()
                    
                    let data = json.value(forKey: "Data") as? NSDictionary ?? [:]
                    
                    self.typeListArr = data.value(forKeyPath: "LeaveTypesList") as? NSArray ?? []
                    
                    self.employeesArr = data.value(forKeyPath: "ResourceList") as? NSArray ?? []
                    
                    self.setIsMyRequests(isMyRequest: true, type: self.leavetype, employeeId: self.empid)
                    
                  //  self.getEmployeesData()
                    
                   // self.setIsMyRequests(isMyRequest: true, type: self.leavetype)
                    
                }
                else if status == 401{
                    
                    self.fromRefresh = "Filter"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    // Hide Loader
                   
                    self.hideGif()
                   
                }
            }
            else {
                // Hide Loader
               
                self.hideGif()
                
                
            }
            
        }
    }
    
    
    func getEmployeesData() {
      
        self.showGif()
       
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
                    self.hideGif()
                    //  ActivityLoader.shared.hideLoader()
                    
                   // let data = json.value(forKey: "Data") as? NSDictionary ?? [:]
                    
                    self.employeesArr = json.value(forKeyPath: "Data") as? NSArray ?? []
                    
                    self.setIsMyRequests(isMyRequest: true, type: self.leavetype, employeeId: self.empid)
                   
                }
                else if status == 401{
                }
                else{
                    // Hide Loader
            
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
    
    
    func managerSummaryCall(leavetype:String, empID:Int, group: DispatchGroup?){
       
        let viewModel = dashboardViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                   // self!.loader.addLoader(view: self!.view)
                    
                    if self!.fromPullRefresh == "Pull"{
                    }
                    else{
                        //self!.showIndicator(withTitle: "Loading...")
                        self?.showGif()
                       // ActivityLoader.shared.showLoaderCentered()
                    }
                    
                  //  self!.showIndicator(withTitle: "")
                   // self!.loader.addLoaderBtn(btn: self!.loginBtn)
                } else {
                    
                    if self!.fromPullRefresh == "Pull"{
                    }
                    else{
                        //self!.hideIndicator()
                        self?.hideGif()
                       // ActivityLoader.shared.hideLoader()
                    }
                    
                   // self!.hideIndicator()
                 //   self!.loader.removeLoader(view: self!.view)
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
                    self.managerSummaryListingArray = viewModel.managerSummaryListArr
                  
                    self.refreshRequestTableView(checkNoRecords: true)
                    
                    self.isAllSelected = false
                    
                    self.checkBoxBtn.setImage(UIImage(named: "BlankBox"), for: .normal)
                    self.approveAllBtn.backgroundColor = .lightGray
                    self.approveAllBtn.tintColor = .white
                    self.approveAllBtn.isUserInteractionEnabled = false
                    
                    self.approveString = ""
                    
                    self.refreshControl.endRefreshing()
                }
                
            }

        }
        viewModel.leaveType = leavetype
        viewModel.empid = empID
        viewModel.callGetManagerListingListingService = true
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
                   // self!.loader.addLoader(view: self!.view)
                   // self!.loader.addLoaderBtn(btn: self!.loginBtn)
                  //  ActivityLoader.shared.showLoaderCentered()
                } else {
                    self!.hideIndicator()
                   // self!.loader.removeLoader(view: self!.view)
                   // self!.loader.removeLoaderBtn(btn: self!.loginBtn)
                  //  ActivityLoader.shared.hideLoader()
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
                   
                    self.fromPullRefresh = "Normal"
                    
                    
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
                            self.setIsMyRequests(isMyRequest: true, type: self.leavetype, employeeId: self.empid)
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
    
    //new code for all
    func changeLeaveStatusCallAll(guid: [String], group: DispatchGroup?){
       
        let viewModel = dashboardViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                    self!.showIndicator(withTitle: "Loading...")
                   // self!.loader.addLoader(view: self!.view)
                   // self!.loader.addLoaderBtn(btn: self!.loginBtn)
                  //  ActivityLoader.shared.showLoaderCentered()
                } else {
                    self!.hideIndicator()
                   // self!.loader.removeLoader(view: self!.view)
                   // self!.loader.removeLoaderBtn(btn: self!.loginBtn)
                  //  ActivityLoader.shared.hideLoader()
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
                   
                    self.fromPullRefresh = "Normal"
                    
                    self.isAllSelected = false
                    
                    self.checkBoxBtn.setImage(UIImage(named: "BlankBox"), for: .normal)
                    self.approveAllBtn.backgroundColor = .lightGray
                    self.approveAllBtn.tintColor = .white
                    self.approveAllBtn.isUserInteractionEnabled = false
                    
                    self.approveString = "Success"
                    
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
                            self.setIsMyRequests(isMyRequest: true, type: self.leavetype, employeeId: self.empid)
                        }
                    })
                }
    
            }

        }
        
        viewModel.guidforall = guid
        viewModel.callChangeLeaveStatusServiceAll = true
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
                        self.getDropdownData()
                    }
                    else if self.fromRefresh == "Summary"{
                        self.setIsMyRequests(isMyRequest: true, type: self.leavetype, employeeId: self.empid)
                    }
                    else if self.fromRefresh == "Change Status"{
                        self.changeLeaveStatusCall(guid: self.guidId, status: self.statusSend, reason: self.reasonTxtSend, group: nil)
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

extension ManagerHomeVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Release the audio player once it's done playing
        audioPlayer = nil
        
        retainSelf = nil
    }
}
