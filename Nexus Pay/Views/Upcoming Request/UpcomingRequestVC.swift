//
//  UpcomingRequestVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 13/04/23.
//

import UIKit
import IBAnimatable
import Alamofire
import FirebaseAnalytics
import SwiftGifOrigin

class UpcomingRequestVC: UIViewController, boolValue {
    
    var leaveSummaryCall = false

    @IBOutlet weak var newFromDateTxtFld: UITextField!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var upcomingRequestTblView: UITableView!
    @IBOutlet weak var fromDateTxtFld: AnimatableTextField!
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet var allTransactionLbl: UILabel!
    @IBOutlet var fromDateView: UIView!
    
    var loader = Loader()
    
    var typeArr = NSArray()
    var statusArr = NSArray()
    
    var typeMutableArr = NSMutableArray()
    var statusMutableArr = NSMutableArray()
    
    var leaveSummaryListingArray : [leaveSummaryList]?
    
    var type = String()
    var status = String()
    var fromdate = String()
    
    var statusCode = Int()
    
    var fromRefresh = String()
    
    let refreshControl = UIRefreshControl()
    
    var fromPullRefresh = "Normal"
    
    var navigationRefresh = ""
    
    
    var text: [String: String] = [:]

        var value: [String: String] = [:]
    
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
        upcomingRequestTblView.register(UpcomingRequestTVC.loadNib(), forCellReuseIdentifier: "UpcomingRequestTVC")
        
        fromDateTxtFld.tintColor = .clear
        newFromDateTxtFld.tintColor = .clear
        
        newFromDateTxtFld.inputView = datePicker
        fromDateTxtFld.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        fromDateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        newFromDateTxtFld.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))

        
//        let view = UIView()
//        upcomingRequestTblView.tableFooterView = view
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
//        refreshControl.tintColor = .appBlue
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        upcomingRequestTblView.addSubview(refreshControl)
        
//        fromPullRefresh = "Normal"
//        getCountryData()
        
    }
    
    func boolValueChange(info: String) {
            navigationRefresh = info
    }
    
    func showGif() {
            // Create an instance of UIImageView with a GIF
        
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = false
        
            guard let gifURL = Bundle.main.url(forResource: "leave-summary-details 1", withExtension: "gif"),
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
                    gifImageView.topAnchor.constraint(equalTo: fromDateView.bottomAnchor, constant: 50), // Adjust the constant as needed
                    gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    gifImageView.bottomAnchor.constraint(equalTo: upcomingRequestTblView.bottomAnchor)
                ])
        }
    
    func hideGif() {
        // Hide the UIImageView or remove it from the superview
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = true
        gifImageView.removeFromSuperview()
        // Additional cleanup or actions can be performed here
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: UpcomingRequestVC.self,
            AnalyticsParameterScreenClass: UpcomingRequestVC.self])
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        
        fromPullRefresh = "Pull"
        
        self.setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.status, leaveFrom: self.fromdate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(navigationRefresh)
        
        if navigationRefresh == "backfromDetail"{
            datePicker.date = Date()
            
            navigationRefresh = ""
            
        }else{
            datePicker.date = Date()
            fromPullRefresh = "Normal"
            statusLbl.text = "All"
            typeLbl.text = "All"
            fromDateTxtFld.text = ""

            type = ""
            status = ""
            fromdate = ""
            
            getCountryData()
        }
        
    }
    
    

    @objc func handleDatePicker(sender: UIDatePicker) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd/MM/yyyy"
          fromDateTxtFld.text = dateFormatter.string(from: sender.date)
        
     }
    
    @objc func doneButtonClicked(_ sender: Any) {
        
        leaveSummaryCall = true
        
        if fromDateTxtFld.text == ""{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY" // Customize the date format as per your requirements

            fromDateTxtFld.text = dateFormatter.string(from: Date())
            
            //fromDateTxtFld.text = String(Date())
            
            let startdate = String(describing: fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            
            self.fromdate = "\(newStartDate)"
            
           // setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.Status, leaveFrom: self.fromdate, empid: self.empid)
            
            
                //your code when clicked on done
            
           // self.fromdate = fromDateTxtFld.text!
            
            self.setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.status, leaveFrom: self.fromdate)
            
        }
        else{
            
            fromPullRefresh = "Normal"
            
            
            let startdate = String(describing: fromDateTxtFld.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
            let newStartDate = startdate.convertdateStringtoNewFormat(currentFormat: "dd/MM/yyyy", toFormat: "YYYY-MM-dd")
            self.fromdate = "\(newStartDate)"
            
            self.setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.status, leaveFrom: self.fromdate)
            
            
        }
        
        
    }
    
    func setIsMyRequests(isMyRequest:Bool, leaveType: String, leaveStatus: String, leaveFrom: String){
        //self.leaveSummaryListingArray?.removeAll()
        self.refreshRequestTableView(checkNoRecords: false)
        leaveSummaryCall(type: leaveType, status: leaveStatus, fromDate: leaveFrom, group: nil)
        
    }
    
    func showNoRecordsLabel(show:Bool){
        self.noDataLbl.isHidden = !show
    }
    
    func refreshRequestTableView(checkNoRecords:Bool){
        self.upcomingRequestTblView.reloadData()
        if checkNoRecords == true{
            if self.leaveSummaryListingArray?.count == 0 {
                self.showNoRecordsLabel(show: true)
                self.upcomingRequestTblView.isHidden = true
                
            }else{
                self.showNoRecordsLabel(show: false)
                self.upcomingRequestTblView.isHidden = false
                
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: UpcomingRequestVC.self])
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectTypeAction(_ sender: Any) {
        
        leaveSummaryCall = true
        
        typeMutableArr.removeAllObjects()

        for index in 0...self.typeArr.count-1 {

            let dict = typeArr[index] as? NSDictionary ?? [:]

            let title = dict.value(forKeyPath: "Text") as? String ?? ""
           // partId = dict.value(forKeyPath: "id") as? Int ?? 0
            self.typeMutableArr.add(String(title))
        }
        
        fromPullRefresh = "Normal"

        RPicker.selectOption(dataArray: (typeMutableArr as! Array<String>)) {[weak self] (selctedText, atIndex) in

            // TODO: Your implementation for selection

            let dict = self!.typeArr[atIndex] as? NSDictionary ?? [:]

            self!.typeLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""

            self!.type = dict.value(forKeyPath: "Text") as? String ?? ""

            self!.setIsMyRequests(isMyRequest: true, leaveType: self!.type, leaveStatus: self!.status, leaveFrom: self!.fromdate)


        }
        
    }
    
    
    @IBAction func selectStatusAction(_ sender: Any) {
        
        leaveSummaryCall = true
        
        fromPullRefresh = "Normal"
        
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
            
            self!.statusLbl.text = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.status = dict.value(forKeyPath: "Text") as? String ?? ""
            
            self!.setIsMyRequests(isMyRequest: true, leaveType: self!.type, leaveStatus: self!.status, leaveFrom: self!.fromdate)
            
                
        }
        
    }
    
    
    @IBAction func clearFilterAction(_ sender: Any) {
        
        leaveSummaryCall = false
        
        Analytics.logEvent("clearFilter_action_ios", parameters: [AnalyticsParameterScreenName: UpcomingRequestVC.self])
        
        fromPullRefresh = "Normal"
        
        self.setIsMyRequests(isMyRequest: true, leaveType: "", leaveStatus: "", leaveFrom: "")
        statusLbl.text = "All"
        typeLbl.text = "All"
        fromDateTxtFld.text = ""
        
        type = ""
        status = ""
        fromdate = ""
        
    }
    
    
    @IBAction func cancelRequestAction(_ sender: Any) {
    }
    
//    @objc func tappedOnStatusButton(_ sender: UIButton) {
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PreviousRequestDetailVC") as! PreviousRequestDetailVC
//        self.navigationController?.pushViewController(secondViewController, animated: true)
//
//    }
    
    @objc func tappedOnEyeButton(_ sender: UIButton) {
        
        Analytics.logEvent("eyeBtn_action_ios", parameters: [AnalyticsParameterScreenName: UpcomingRequestVC.self])
        
        let leaves = self.leaveSummaryListingArray![sender.tag]
        let guidId = leaves.Guid ?? ""
       // let leaveStatus = leaves.LeaveStatus ?? ""
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PreviousRequestDetailVC") as! PreviousRequestDetailVC
        secondViewController.guid = guidId
       // secondViewController.status = leaveStatus
        //navigationRefresh = true
        //secondViewController.navigationRefresh = navigationRefresh
        //print(navigationRefresh)
        //print(secondViewController.navigationRefresh)
        
        secondViewController.delegate = self
       
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
}

extension UpcomingRequestVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.leaveSummaryListingArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let Categoriescell : UpcomingRequestTVC = tableView.dequeueReusableCell(withIdentifier: "UpcomingRequestTVC", for: indexPath) as! UpcomingRequestTVC
        
        Categoriescell.selectionStyle = .none
        
        let leaves = self.leaveSummaryListingArray![indexPath.row]
        Categoriescell.setUI(leaveBalance: leaves)
        
      //  Categoriescell.statusBtn.tag = indexPath.row
      //  Categoriescell.statusBtn.addTarget(self, action: #selector(tappedOnStatusButton), for: .touchUpInside)
        
        Categoriescell.eyeBtn.tag = indexPath.row
        Categoriescell.eyeBtn.addTarget(self, action: #selector(tappedOnEyeButton), for: .touchUpInside)
            
        return Categoriescell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 52
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        guard let leaves = self.leaveSummaryListingArray?[indexPath.row] else {
//            return nil
//        }
//        
//        // Check the leaveStatus
//        if leaves.LeaveStatus == "Withdrawn" {
//            // If leaveStatus is "Withdrawn", return nil to disable swipe action
//            return nil
//        } else if leaves.LeaveStatus == "Approved" {
//            // If leaveStatus is "Approved", create a swipe action to cancel the request
//            let cancelAction = UIContextualAction(style: .destructive, title: "Cancel Request") { (action, view, completionHandler) in
//                // Your logic to cancel the request
//                
//                self.changeLeaveStatusCall(guid: leaves.Guid ?? "", status: "Cancelled", reason: "", group: nil)
//                
//                completionHandler(true)
//            }
//            
//            // Create swipe actions configuration with the cancel action
//            let configuration = UISwipeActionsConfiguration(actions: [cancelAction])
//            
//            // Prevent full swipe to delete
//            configuration.performsFirstActionWithFullSwipe = false
//            
//            
//            
//            return configuration
//        } else if leaves.LeaveStatus == "Pending" {
//            // If leaveStatus is "Approved", create a swipe action to cancel the request
//            let cancelAction = UIContextualAction(style: .destructive, title: "Withdraw") { (action, view, completionHandler) in
//                // Your logic to cancel the request
//                self.changeLeaveStatusCall(guid: leaves.Guid ?? "", status: "Withdrawn", reason: "", group: nil)
//                
//                completionHandler(true)
//            }
//            
//            // Create swipe actions configuration with the cancel action
//            let configuration = UISwipeActionsConfiguration(actions: [cancelAction])
//            
//            // Prevent full swipe to delete
//            configuration.performsFirstActionWithFullSwipe = false
//            
//            return configuration
//        }else {
//            return nil // Return nil for any other status (you can adjust this logic as needed)
//        }
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let leaves = self.leaveSummaryListingArray?[indexPath.row] else {
            return nil
        }
        
        // Check the leaveStatus
        if leaves.LeaveStatus == "Withdrawn" {
            // If leaveStatus is "Withdrawn", return nil to disable swipe action
            return nil
        } else if leaves.LeaveStatus == "Approved" {
            // If leaveStatus is "Approved", create a swipe action to cancel the request
            let cancelAction = UIContextualAction(style: .destructive, title: "Cancel Request") { (action, view, completionHandler) in
                // Your logic to cancel the request
                self.changeLeaveStatusCall(guid: leaves.Guid ?? "", status: "Cancelled", reason: "", group: nil)
                completionHandler(true)
            }
            
            // Create swipe actions configuration with the cancel action
            let configuration = UISwipeActionsConfiguration(actions: [cancelAction])
            
            // Prevent full swipe to delete
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        } else if leaves.LeaveStatus == "Pending" {
            // If leaveStatus is "Pending", create a swipe action to withdraw the request
            let withdrawAction = UIContextualAction(style: .normal, title: "Withdraw") { (action, view, completionHandler) in
                // Your logic to withdraw the request
                self.changeLeaveStatusCall(guid: leaves.Guid ?? "", status: "Withdrawn", reason: "", group: nil)
                completionHandler(true)
            }
            
            // Customize the appearance of the "Withdraw" action
            withdrawAction.backgroundColor = .appBlue // Set the background color to blue
            withdrawAction.title = "Withdraw"
            withdrawAction.setTitleTextColor(.white) // Set the text color to white
            
            // Create swipe actions configuration with the withdraw action
            let configuration = UISwipeActionsConfiguration(actions: [withdrawAction])
            
            // Prevent full swipe to delete
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        } else {
            return nil // Return nil for any other status (you can adjust this logic as needed)
        }
    }

    
 
}

// Extension to add setTitleTextColor method to UIContextualAction
extension UIContextualAction {
    func setTitleTextColor(_ color: UIColor) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: UIFont.systemFont(ofSize: 17) // You can adjust the font size if needed
        ]
        self.title = NSAttributedString(string: self.title ?? "", attributes: attributes).string
    }
}


extension UpcomingRequestVC{
    
    
    //================================
            //MARK: - Api's Response
            //================================
    //    MARK: - Call Country Listing APi
            
    func getCountryData() {
                
        // Show Loder
       // loader.addLoader(view: self.view)
        //self.showIndicator(withTitle: "Loading...")
        self.showGif()
       // ActivityLoader.shared.showLoaderCentered()
        
        // Get AutorizationToken
       // let AutorizationToken = UserDefaults.standard.string(forKey: "UserAuthorisationToken") ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
        ]
        
        AF.request("\(APIConstants.Collective.authBaseURL)ApplyRequest/GetLeaveSummaryFilter", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    
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
                            //self.hideGif()
                            //ActivityLoader.shared.hideLoader()
                            
                            let data = json.value(forKey: "Data") as? NSDictionary ?? [:]

                            self.typeArr = data.value(forKeyPath: "LeaveList") as? NSArray ?? []
                            self.statusArr = data.value(forKeyPath: "StatusList") as? NSArray ?? []
                            
                            self.setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.status, leaveFrom: self.fromdate)
                            
                        }
                        else if status == 401{
                            
                            self.fromRefresh = "Filter"
                            
                            self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                        }
                        else{
                            // Hide Loader
                            //self.hideIndicator()
                            self.hideGif()
                            ActivityLoader.shared.hideLoader()
                          //  self.loader.removeLoader(view: self.view)
                            //self.showAlert(msg: message)
                        }
                    }
                    else {
                        // Hide Loader
                        //self.loader.removeLoader(view: self.view)
                        //self.hideIndicator()
                        self.hideGif()
                        ActivityLoader.shared.hideLoader()
            
                    }
                    
                }
            }
    
    //new code
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
                        //self.shadowView.isHidden = true
                        //self.navigationController?.popViewController(animated: true)
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainVC") as! HomeMainVC
                        self.navigationController?.pushViewController(secondViewController, animated: true)
                        
                        //self.getCountryData()
                        
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
    
    
    func leaveSummaryCall(type: String, status: String, fromDate: String, group: DispatchGroup?){
        
        let viewModel = dashboardViewModel()
        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                    
                    if self!.fromPullRefresh == "Pull"{
                    }
                    else{
                        //self!.showIndicator(withTitle: "Loading...")
                        if self!.leaveSummaryCall == true{
                            self?.showGif()
                        }
                        //self?.showGif()
                       // ActivityLoader.shared.showLoaderCentered()
                    }
                    
                    
                  //  self!.loader.addLoader(view: self!.view)
                   // self!.loader.addLoaderBtn(btn: self!.loginBtn)
                } else {
                    
                    if self!.fromPullRefresh == "Pull"{
                    }
                    else{
                        //self!.hideIndicator()
                        if self!.leaveSummaryCall == true{
                            self?.hideGif()
                            self?.leaveSummaryCall = false
                        }
                        self?.hideGif()
                       // ActivityLoader.shared.hideLoader()
                    }
                    
                    //self!.loader.removeLoader(view: self!.view)
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
                    self.leaveSummaryListingArray = viewModel.leaveSummaryListArr
                  
                    self.refreshRequestTableView(checkNoRecords: true)
                    
                    self.refreshControl.endRefreshing()
                }
              
            }

        }
        viewModel.type = type
        viewModel.status = status
        viewModel.fromDate = fromDate
        viewModel.callGetLeaveSummaryListingService = true
    }
    
    
    func refreshTokenCall(accesstoken: String, refreshtoken: String, group: DispatchGroup?){
       
        let viewModel = dashboardViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                   // ActivityLoader.shared.showLoaderCentered()
                    //self!.showIndicator(withTitle: "Loading...")
                    self?.showGif()
                   // self!.loader.addLoader(view: self!.view)
                   // self!.loader.addLoaderBtn(btn: self!.loginBtn)
                } else {
                   // ActivityLoader.shared.hideLoader()
                    //self!.hideIndicator()
                    self?.hideGif()
                    //self!.loader.removeLoader(view: self!.view)
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
                        self.getCountryData()
                    }
                    else{
                        self.setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.status, leaveFrom: self.fromdate)
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
