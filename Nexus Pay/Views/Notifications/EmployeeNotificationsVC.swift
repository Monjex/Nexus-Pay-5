//
//  EmployeeNotificationsVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 05/07/23.
//

import UIKit
import FirebaseAnalytics
import SwiftGifOrigin

protocol NotificationDecreaseBool: AnyObject {
    func BacktoNotification(info: String)
}

class EmployeeNotificationsVC: UIViewController, NotificationDecreaseDelegate, NotificationDecreaseDelegate1 {
   
    @IBOutlet weak var notificationsTblView: UITableView!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    @IBOutlet var notificationView: UIView!
    
    var gifImageView: UIImageView! //gifOutlet
    
    var notificationsListingArray : [notificationsList]?
    
    var loader = Loader()
    
    var statusCode = Int()
    
    var notiCount = ""
    
    weak var delegate: NotificationDecreaseBool? = nil
    
    func BacktoNotification(info: String) {
        notiCount = info
       
    }
    
    func BacktoNotification1(info: String) {
        notiCount = info
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        notificationsTblView.register(EmployeeNotificationsTVC.loadNib(), forCellReuseIdentifier: "EmployeeNotificationsTVC")
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBack1(_:)))
        swipeRight.edges = .left
        view.addGestureRecognizer(swipeRight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenName: EmployeeNotificationsVC.self,
            AnalyticsParameterScreenClass: EmployeeNotificationsVC.self])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setIsMyRequests(isMyRequest: true)
    }
    
    @objc func handleSwipeBack1(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.delegate?.BacktoNotification(info: notiCount)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showGif() {
            // Create an instance of UIImageView with a GIF
        
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = false
        
            guard let gifURL = Bundle.main.url(forResource: "notifications-screen", withExtension: "gif"),
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
                    gifImageView.topAnchor.constraint(equalTo: notificationView.bottomAnchor), // Adjust the constant as needed
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
    
    func setIsMyRequests(isMyRequest:Bool){
        self.notificationsListingArray?.removeAll()
        self.refreshRequestTableView(checkNoRecords: false)
        notificationsListCall(group: nil)
        
    }
    
    func showNoRecordsLabel(show:Bool){
        self.noDataFoundLbl.isHidden = !show
    }
    
    func refreshRequestTableView(checkNoRecords:Bool){
        self.notificationsTblView.reloadData()
        if checkNoRecords == true{
            if self.notificationsListingArray?.count == 0 {
                self.showNoRecordsLabel(show: true)
                self.notificationsTblView.isHidden = true
                
            }else{
                self.showNoRecordsLabel(show: false)
                self.notificationsTblView.isHidden = false
                
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        self.delegate?.BacktoNotification(info: notiCount)
        //Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: EmployeeNotificationsVC.self])
        navigationController?.popViewController(animated: true)
    }
    
}

extension EmployeeNotificationsVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.notificationsListingArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let Categoriescell : EmployeeNotificationsTVC = tableView.dequeueReusableCell(withIdentifier: "EmployeeNotificationsTVC", for: indexPath) as! EmployeeNotificationsTVC
        
        Categoriescell.selectionStyle = .none
        
        let notifications = self.notificationsListingArray![indexPath.row]
        Categoriescell.setUI(notification: notifications)
            
        return Categoriescell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 92
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notifications = self.notificationsListingArray![indexPath.row]
        
        let IsManagerView = notifications.IsManagerView ?? false
        
        let NotificationGuid = notifications.NotificationGuid ?? ""
        let Leave_Guid = notifications.Leave_Guid ?? ""
        
        if IsManagerView == true{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ManagerLeaveDetailsVC") as! ManagerLeaveDetailsVC
            secondViewController.guid = Leave_Guid
            secondViewController.notificationguid = NotificationGuid
            secondViewController.delegate2 = self
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PreviousRequestDetailVC") as! PreviousRequestDetailVC
            secondViewController.guid = Leave_Guid
            secondViewController.notificationguid = NotificationGuid
            secondViewController.delegate2 = self
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        
        
    }
    
}

extension EmployeeNotificationsVC{
    
    
    func notificationsListCall(group: DispatchGroup?){
        
        let viewModel = dashboardViewModel()
        
        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                    if viewModel.isLoading {
                      
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
            
            DispatchQueue.main.async {
                
                group?.leave()
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 401{
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    self.notificationsListingArray = viewModel.notificationsListArr
                    
                    self.refreshRequestTableView(checkNoRecords: true)
                }
                
            }
            
        }
        
        viewModel.callGetNotificationsListListingService = true
    }
    
    
    func refreshTokenCall(accesstoken: String, refreshtoken: String, group: DispatchGroup?){
       
        let viewModel = dashboardViewModel()

        // For Loading Indicator
        viewModel.updateLoadingStatus = { [weak self] () in
            guard self != nil else { return }
            DispatchQueue.main.async {
                if group == nil {
                if viewModel.isLoading {
                  
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

            DispatchQueue.main.async {
                
                group?.leave()
                
                self.statusCode = viewModel.apiStatus ?? 0
                
                if self.statusCode == 200{
                    
                    self.setIsMyRequests(isMyRequest: true)
                    
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
