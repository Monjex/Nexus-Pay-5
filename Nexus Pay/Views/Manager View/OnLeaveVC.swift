//
//  OnLeaveVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 09/06/23.
//

import UIKit
import FirebaseAnalytics
import SwiftGifOrigin

class OnLeaveVC: UIViewController {
    
    @IBOutlet weak var onLeaveTblView: UITableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet var employeeView: UIView!
    
    var upcomingLeaveSummaryListingArray : [managerSummaryList]?
    
    var loader = Loader()
    
    var date = String()
    
    var currentDate = Date()
    
    var statusCode = Int()
    var gifImageView: UIImageView! //gifOutlet
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBack(_:)))
        swipeRight.edges = .left
        view.addGestureRecognizer(swipeRight)
        
        let view = UIView()
        onLeaveTblView.tableFooterView = view
        
        onLeaveTblView.register(OnLeaveTVC.loadNib(), forCellReuseIdentifier: "OnLeaveTVC")
        
        dateLbl.text = Date.getCurrentDate()
        
        let currentdate = Date.getCurrentDateChange()

        date = "\(currentdate)"
        
        setIsMyRequests(isMyRequest: true, leaveFrom: date)
    }
    
    func showGif() {
            // Create an instance of UIImageView with a GIF
        
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = false
        
            guard let gifURL = Bundle.main.url(forResource: "onleave", withExtension: "gif"),
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
                    gifImageView.topAnchor.constraint(equalTo: employeeView.bottomAnchor), // Adjust the constant as needed
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
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: OnLeaveVC.self,
            AnalyticsParameterScreenClass: OnLeaveVC.self])
    }
    
    func setIsMyRequests(isMyRequest:Bool, leaveFrom: String){
        self.upcomingLeaveSummaryListingArray?.removeAll()
        self.refreshRequestTableView(checkNoRecords: false)
        managerLeaveByDateSummaryCall(fromDate: date, group: nil)
        
    }
    
    func showNoRecordsLabel(show:Bool){
        self.noDataLbl.isHidden = !show
    }
    
    func refreshRequestTableView(checkNoRecords:Bool){
        self.onLeaveTblView.reloadData()
        if checkNoRecords == true{
            if self.upcomingLeaveSummaryListingArray?.count == 0 {
                self.showNoRecordsLabel(show: true)
                self.onLeaveTblView.isHidden = true
                
            }else{
                self.showNoRecordsLabel(show: false)
                self.onLeaveTblView.isHidden = false
                
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: OnLeaveVC.self])
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func rightArrowAction(_ sender: Any) {
        
        Analytics.logEvent("rightArrow_action_ios", parameters: [AnalyticsParameterScreenName: OnLeaveVC.self])
        
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        updateDateLabel() // Update the label with the new date
        
    }
    
    
    @IBAction func leftArrowAction(_ sender: Any) {
        
        Analytics.logEvent("leftArrow_action_ios", parameters: [AnalyticsParameterScreenName: OnLeaveVC.self])
        
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        updateDateLabel() // Update the label with the new date
    }
    
    func updateDateLabel() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: currentDate)
        dateLbl.text = dateString
        
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "YYYY-MM-dd"
        let dateStringFormat = dateFormatterString.string(from: currentDate)
        
//        let dateFormatterSend = DateFormatter()
//        dateFormatterSend.dateFormat = "'T'HH:mm:ss.SSS'Z'"
//        let currentDate = Date()
//        let formattedDateTo = dateFormatterSend.string(from: currentDate)
        
        date = "\(dateStringFormat)"
       
        
        setIsMyRequests(isMyRequest: true, leaveFrom: date)

    }
    
}

extension OnLeaveVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.upcomingLeaveSummaryListingArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Categoriescell : OnLeaveTVC = tableView.dequeueReusableCell(withIdentifier: "OnLeaveTVC", for: indexPath) as! OnLeaveTVC
        
       // Categoriescell.menuLbl.text = menusArr[indexPath.row]
        Categoriescell.selectionStyle = .none
        
        if indexPath.row % 2 == 0{
            Categoriescell.mainView.backgroundColor = UIColor.companyHolidays
        }
        else{
            Categoriescell.mainView.backgroundColor = UIColor.white
        }
        
        let leaves = self.upcomingLeaveSummaryListingArray![indexPath.row]
        Categoriescell.setUI(leaveBalance: leaves)
        
        return Categoriescell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }
}

extension OnLeaveVC{
    
    
    //================================
    //MARK: - Api's Response
    //================================
    //    MARK: - Call Country Listing APi
    
    func managerLeaveByDateSummaryCall(fromDate: String, group: DispatchGroup?){
       
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
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    self.upcomingLeaveSummaryListingArray = viewModel.managerSummaryListArr
                  
                    self.refreshRequestTableView(checkNoRecords: true)
                }
              
            }

        }
        
        viewModel.fromDate = fromDate
        viewModel.callGetManagerSummaryByDateListingListingService = true
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
                    
                    self.setIsMyRequests(isMyRequest: true, leaveFrom: self.date)
                    
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
