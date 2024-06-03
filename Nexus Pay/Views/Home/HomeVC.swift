//
//  HomeVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 17/01/23.
//

import UIKit
import SideMenu
import FSCalendar
import IBAnimatable
import MBProgressHUD
import NVActivityIndicatorView
import Alamofire
import FirebaseAnalytics
//import SwiftGifOrigin
import Reachability

class HomeVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, NotificationDecreaseBool {
   
    @IBOutlet weak var managerViewTop: AnimatableView!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var leaveBalanceTblView: UITableView!
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var managerViewBtn: UIButton!
    @IBOutlet var homeView: UIView!
    @IBOutlet var fakeView: UIView!
    
    var gifImageView: UIImageView! //gifOutlet
    
    var loader = Loader()
    
    var leaveBalanceListingArray : [leaveBalanceList]?
    var calenderBalanceListingArray : [leaveCalenderList]?
    
    var statusCode = Int()
    
    var yearInt = Int()
    var monthInt = Int()
    
    var count = Int()
    
   // var highlightedDates = ["2023-06-05", "2023-06-20", "2023-06-25", "2023-07-25"]
    
    var highlightedDates: [Date] = []
    var leaveTypes: [Date: String] = [:]
    var requestTypes: [Date: String] = [:]
    
    var firstTime = 0
    
    let dateFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(UserDefaults.standard.bool(forKey: "IsManager"))
        
       // print(AuthUtils.getIsManager())
        
        //GetYearandMonth()
        
        var reachability: Reachability { try! Reachability() }
                
                if reachability.connection != .unavailable {
                    GetYearandMonth()
                }
                else{
                    showMessage("Alert", "Please check your internet connection!")
                }
        
        
        if UserDefaults.standard.bool(forKey: "IsManager") == true{
            managerViewBtn.isHidden = false
            managerViewTop.isHidden = false
        }
        else{
            managerViewBtn.isHidden = true
            managerViewTop.isHidden = true
        }
        
//        if AuthUtils.getIsManager() == true{
//            managerViewBtn.isHidden = false
//            managerViewTop.isHidden = false
//
//        }
//        else{
//            managerViewBtn.isHidden = true
//            managerViewTop.isHidden = true
//        }
        
        calenderView.layer.cornerRadius = 8
        leaveBalanceTblView.register(LeaveBalanceTVC.loadNib(), forCellReuseIdentifier: "LeaveBalanceTVC")
        
        calenderView.layer.shadowColor = UIColor.black.cgColor
        calenderView.layer.shadowOpacity = 0.2
        calenderView.layer.shadowOffset = .zero
        calenderView.layer.shadowRadius = 4
        
        
       // GetYearandMonth()
       // GetYearandMonth()
        
        //print(AuthUtils.getRefreshToken())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.calenderView.reloadData()
        
        let currentDate = Date()

       // calenderView.currentPage = currentDate
        
//        GetYearandMonth()

    }
    
    func BacktoNotification(info: String) {
        
        print(info)
        if info == ""{
            
        }else{
            self.calenderView.reloadData()
            //let currentDate = Date()
            GetYearandMonth()
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: HomeVC.self,
                                       AnalyticsParameterScreenClass: HomeVC.self])
    }
    
    func showGif() {
            // Create an instance of UIImageView with a GIF
        
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = false
        
            guard let gifURL = Bundle.main.url(forResource: "calendar88", withExtension: "gif"),
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
                    gifImageView.topAnchor.constraint(equalTo: homeView.bottomAnchor), // Adjust the constant as needed
                    gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    gifImageView.bottomAnchor.constraint(equalTo: fakeView.topAnchor)
                ])
        }
    
    func hideGif() {
        // Hide the UIImageView or remove it from the superview
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = true
        gifImageView.removeFromSuperview()
        // Additional cleanup or actions can be performed here
    }
    
    func GetYearandMonth(){
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy"

        let selectedDateString = dateFormatter.string(from: Date())

      //   print(selectedDateString)
        
        
        let dateFormattermonth = DateFormatter()

        dateFormattermonth.dateFormat = "MM"

        let selectedDateStringMonth = dateFormattermonth.string(from: Date())

        // print(selectedDateStringMonth)
        
        yearInt = Int(selectedDateString)!
         monthInt = Int(selectedDateStringMonth)!
        
       // dashboardCall(year: yearInt ?? 2023, month: monthInt ?? 6, group: nil)
        
       // setIsMyRequests(isMyRequest: true, year: yearInt, month: monthInt)
        
        calendarCurrentPageDidChange(calenderView)
        
    }
    
    
    func setIsMyRequests(isMyRequest:Bool, year: Int, month: Int){
        self.leaveBalanceListingArray?.removeAll()
        self.refreshRequestTableView(checkNoRecords: false)
        dashboardCall(year: year, month: month, group: nil)
        
    }
    
    func showNoRecordsLabel(show:Bool){
        //self.noAddressLbl.isHidden = !show
    }
    
    func refreshRequestTableView(checkNoRecords:Bool){
        self.leaveBalanceTblView.reloadData()
        if checkNoRecords == true{
            if self.leaveBalanceListingArray?.count == 0 {
                self.showNoRecordsLabel(show: true)
                self.leaveBalanceTblView.isHidden = true
                
            }else{
                self.showNoRecordsLabel(show: false)
                self.leaveBalanceTblView.isHidden = false
                
            }
        }
    }
    
    
    @IBAction func bellAction(_ sender: Any) {
        
        Analytics.logEvent("bell_action_ios", parameters: [AnalyticsParameterScreenName: HomeVC.self])
        
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeNotificationsVC") as! EmployeeNotificationsVC
        secondViewController.delegate = self
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func managerViewAction(_ sender: Any) {
        
        Analytics.logEvent("managerView_action_ios", parameters: [AnalyticsParameterScreenName: HomeVC.self])
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ManagerHomeVC") as! ManagerHomeVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        Analytics.logEvent("logout_action_ios", parameters: [AnalyticsParameterScreenName: HomeVC.self])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            
            self.showMessageCustom("Alert", "Are you sure you want to logout?", options: ["Yes","No"], style: .alert) { (index) in
                if index == 0 {
                    
                    self.Logout()
                  
                }else{
                    print("no")
                }
            }
        }
        
    }
    
    @IBAction func calenderAction(_ sender: Any) {
        
        Analytics.logEvent("calender_action_ios", parameters: [AnalyticsParameterScreenName: HomeVC.self])
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "CompanyHolidaysVC") as! CompanyHolidaysVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            let currentPage = calendar.currentPage
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yyyy" // You can customize the date format as needed
            let monthYearString = dateFormatter.string(from: currentPage)
            print("Current page: \(monthYearString)")
            
            // Split the formatted string into month and year
            let components = monthYearString.split(separator: "/")
            
            if components.count == 2 {
                if let monthIntCal = Int(components[0]) {
                    if let yearIntCal = Int(components[1]) {
                        setIsMyRequests(isMyRequest: true, year: yearIntCal, month: monthIntCal)
                    }
                }
            }
        }
    
    
//    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//
//                let currentPage = calendar.currentPage
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "MM"
//                let monthYearString = dateFormatter.string(from: currentPage)
//                print("Current page: \(monthYearString)")
//
//                let monthIntCal = Int(monthYearString)
//
//                setIsMyRequests(isMyRequest: true, year: yearInt, month: monthIntCal ?? 0)
//
//            }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

                let date = date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                let maindate = dateFormatter.string(from: date)
        
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyRequestVC") as! ApplyRequestVC
                vc.comeFromCal = "Calender"
                vc.comeFrom = "Home"
                vc.callGetDays = "Calender"
                vc.calDate = maindate
                self.navigationController?.pushViewController(vc, animated: true)
        }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {

            if let status = requestTypes[date] {

                if status == ""{
                    if let leaveAbbreviation = leaveTypes[date] {
                        switch leaveAbbreviation {
                            case "RH":
                                return UIColor.red
                            case "GH":
                                return UIColor.approved
                            default:
                                return nil
                    
                        }
                    
                    }
                }
                else{
                    switch status {
                        case "Pending":
                            return UIColor.pending
                        case "Approved":
                            return UIColor.approved
                        default:
                            return nil

                    }
                }
            }
    
            return nil

        }

        
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
           return leaveTypes[date]
       }
    
    @objc func tappedOnApplyButton(_ sender: UIButton) {
        
        Analytics.logEvent("apply_action_ios", parameters: [AnalyticsParameterScreenName: HomeVC.self])
        
        let leaves = self.leaveBalanceListingArray![sender.tag]
        let leavetype = leaves.LeaveType ?? ""
        let balance = leaves.Balance ?? 0
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ApplyRequestVC") as! ApplyRequestVC
        secondViewController.comeFrom = "Home"
        secondViewController.callGetDays = "Home"
        secondViewController.leaveBal = balance
        secondViewController.type = leavetype
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

}

extension HomeVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.leaveBalanceListingArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Categoriescell : LeaveBalanceTVC = tableView.dequeueReusableCell(withIdentifier: "LeaveBalanceTVC", for: indexPath) as! LeaveBalanceTVC
        
       // Categoriescell.menuLbl.text = menusArr[indexPath.row]
        Categoriescell.selectionStyle = .none
        
        let leaves = self.leaveBalanceListingArray![indexPath.row]
        Categoriescell.setUI(leaveBalance: leaves)
        
        Categoriescell.applyBtn.tag = indexPath.row
        Categoriescell.applyBtn.addTarget(self, action: #selector(tappedOnApplyButton), for: .touchUpInside)
        
        return Categoriescell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIDevice.current.name == "iPhone 12 mini"{
            if indexPath.row == 0{
                return 140
            }else{
                return 120
            }
        }else{
            
            if indexPath.row == 0{
                return 120
            }else{
                return 110
            }
            
        }
        
    }
}


extension HomeVC{
    
    func dashboardCall(year:Int, month:Int, group: DispatchGroup?){
       
        let viewModel = dashboardViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {

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
                
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 401{
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    
                    self.count =  viewModel.notiCount ?? 0
                    
                    if self.count == 0{
                        self.countLbl.isHidden = true
                    }
                    else{
                        self.countLbl.isHidden = false
                        self.countLbl.text = "\(self.count)"
                    }
                    
                    self.leaveBalanceListingArray = viewModel.leaveBalanceListArr
                    self.calenderBalanceListingArray = viewModel.calenderBalanceListArr
                    
                    for item in self.calenderBalanceListingArray! {
                        
                        if let dateString = item.Date, let leaveAbbreviation = item.LeaveAbbreviation, let status = item.RequestStatus {
                            
                            if let date = self.dateFormatter.date(from: dateString) {
                                
                                self.highlightedDates.append(date)
                                
                                self.leaveTypes[date] = leaveAbbreviation
                                
                                self.requestTypes[date] = status
                                
                                
                            }
                            
                        }
                        
                    }
                  
                    self.calenderView.delegate = self
                    self.calenderView.dataSource = self
                    
                    self.calenderView.reloadData()
            
                    self.refreshRequestTableView(checkNoRecords: true)
                }
                
                
                group?.leave()
            }

        }
        viewModel.year = year
        viewModel.month = month
        viewModel.callGetDashboardListingService = true
    }
    
    
    
    //================================
            //MARK: - Api's Response
            //================================
    //    MARK: - Call Country Listing APi
    
    
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
                   // self!.loader.addLoader(view: self!.view)
                   // self!.loader.addLoaderBtn(btn: self!.loginBtn)
                } else {
                  //  ActivityLoader.shared.hideLoader()
                   // self!.hideIndicator()
                    self?.hideGif()
                  //  self!.loader.removeLoader(view: self!.view)
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
                    self.setIsMyRequests(isMyRequest: true, year: self.yearInt, month: self.monthInt)
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

class ActivityLoader {

    static let shared = ActivityLoader()

    private var activityIndicatorView: NVActivityIndicatorView?

    private var originalUserInteractionEnabled: Bool = true
    private init() { }

    func showLoaderCentered(type: NVActivityIndicatorType = .ballRotateChase, color: UIColor = .init(red: 16/255, green: 69/255, blue: 120/255, alpha: 1.0), padding: CGFloat = 10, size: CGSize = CGSize(width: 74, height: 74)) {

         let window = UIApplication.shared.windows.first

        originalUserInteractionEnabled = window!.rootViewController?.view.isUserInteractionEnabled ?? true

        window!.rootViewController?.view.isUserInteractionEnabled = false
            let frame = CGRect(x: 0, y: 0, width: window!.bounds.width, height: window!.bounds.height)

            // Create a semi-transparent background view

            let backgroundView = UIView(frame: frame)

         backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

            backgroundView.tag = 123 // You can use a unique tag to identify and remove it later.

            activityIndicatorView = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)

            activityIndicatorView?.frame.size = size

            // Add the background view first to the window

            window!.addSubview(backgroundView)

            activityIndicatorView?.startAnimating()

            activityIndicatorView?.center = window!.center

            activityIndicatorView?.backgroundColor = .white

            activityIndicatorView?.layer.cornerRadius = 8

            // Add the loader on top of the background view to the window

            window!.addSubview(activityIndicatorView!)

        

    }

    func hideLoader() {

        let window = UIApplication.shared.windows.first

        window!.rootViewController?.view.isUserInteractionEnabled = true

        // Remove the loader

        activityIndicatorView?.stopAnimating()

        activityIndicatorView?.removeFromSuperview()

      //  activityIndicatorView = nil

        // Find and remove the background view

        if let backgroundView = UIApplication.shared.windows.first?.viewWithTag(123) {

            backgroundView.removeFromSuperview()

        }

    }

}
