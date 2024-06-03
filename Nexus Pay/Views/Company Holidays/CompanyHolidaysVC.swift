//
//  CompanyHolidaysVC.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 17/04/23.
//

import UIKit
import Alamofire
import FirebaseAnalytics
import SwiftGifOrigin

class CompanyHolidaysVC: UIViewController, UIDocumentInteractionControllerDelegate, UIDocumentPickerDelegate {
    
    @IBOutlet weak var companyHolidaysTblView: UITableView!
    @IBOutlet var dateHolidayView: UIView!
    
    var holidayListingArray : [holidayList]?
    
    var loader = Loader()
    
    var statusCode = Int()
    
    var fromRefresh = String()

    var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        companyHolidaysTblView.register(CompanyHolidaysTVC.loadNib(), forCellReuseIdentifier: "CompanyHolidaysTVC")
        
        let swipeRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBack(_:)))
        swipeRight.edges = .left
        view.addGestureRecognizer(swipeRight)
        
        setIsMyRequests(isMyRequest: true)
    }
    
    func showGif() {
            // Create an instance of UIImageView with a GIF
        
        let window = UIApplication.shared.windows.first
        window!.rootViewController?.view.isUserInteractionEnabled = false
        
            guard let gifURL = Bundle.main.url(forResource: "company-holidays", withExtension: "gif"),
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
                    gifImageView.topAnchor.constraint(equalTo: dateHolidayView.bottomAnchor), // Adjust the constant as needed
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
            parameters: [AnalyticsParameterScreenName: CompanyHolidaysVC.self,
            AnalyticsParameterScreenClass: CompanyHolidaysVC.self])
    }
    
    func setIsMyRequests(isMyRequest:Bool){
        self.holidayListingArray?.removeAll()
        self.refreshRequestTableView(checkNoRecords: false)
        holidayListCall(group: nil)
        
    }
    
    func showNoRecordsLabel(show:Bool){
        //self.noDataLbl.isHidden = !show
    }
    
    func refreshRequestTableView(checkNoRecords:Bool){
        self.companyHolidaysTblView.reloadData()
        if checkNoRecords == true{
            if self.holidayListingArray?.count == 0 {
                self.showNoRecordsLabel(show: true)
                self.companyHolidaysTblView.isHidden = true
                
            }else{
                self.showNoRecordsLabel(show: false)
                self.companyHolidaysTblView.isHidden = false
                
            }
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        Analytics.logEvent("back_action_ios", parameters: [AnalyticsParameterScreenName: CompanyHolidaysVC.self])
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func calenderAction(_ sender: Any) {
        
        Analytics.logEvent("calender_action_ios", parameters: [AnalyticsParameterScreenName: CompanyHolidaysVC.self])
        
        getpdfData()
    }
    
    @objc func tappedOnTypeButton(_ sender: UIButton) {
        
        Analytics.logEvent("type_action_ios", parameters: [AnalyticsParameterScreenName: CompanyHolidaysVC.self])
        
        let leaves = self.holidayListingArray![sender.tag]
        let holiday = leaves.Holiday ?? ""
        //let date = leaves.Date ?? ""
       // let balance = leaves.Balance ?? ""
       // let fromdate = leaves.FromDate ?? ""
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ApplyRequestVC") as! ApplyRequestVC
        secondViewController.comeFromHolidays = "Yes"
        secondViewController.comeFrom = "Holidays"
        secondViewController.rhHolidayName = holiday
        secondViewController.holidaylist = leaves
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {

        return self

    }
    
}

extension CompanyHolidaysVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.holidayListingArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let Categoriescell : CompanyHolidaysTVC = tableView.dequeueReusableCell(withIdentifier: "CompanyHolidaysTVC", for: indexPath) as! CompanyHolidaysTVC
        
        Categoriescell.selectionStyle = .none
        
        let holiday = self.holidayListingArray![indexPath.row]
        Categoriescell.setUI(holiday: holiday)
        
        Categoriescell.typeBtn.tag = indexPath.row
        Categoriescell.typeBtn.addTarget(self, action: #selector(tappedOnTypeButton), for: .touchUpInside)
        
        if indexPath.row % 2 == 0{
            Categoriescell.mainView.backgroundColor = UIColor.companyHolidays
        }
        else{
            Categoriescell.mainView.backgroundColor = UIColor.white
        }
            
        return Categoriescell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 48
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}

extension CompanyHolidaysVC{
    
    
    func holidayListCall(group: DispatchGroup?){
       
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
                    
                   // self.fromRefresh = "Holiday List"
                    
                    self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                }
                else{
                    self.holidayListingArray = viewModel.holidayListArr
                  
                    self.refreshRequestTableView(checkNoRecords: true)
                }
              
            }

        }
        
        viewModel.callGetHolidayListListingService = true
    }
    
    
    func getpdfData() {
        
        // Show Loder
       // loader.addLoader(view: self.view)
        self.showIndicator(withTitle: "Loading...")
      //  ActivityLoader.shared.showLoaderCentered()
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
        ]
        
        AF.request("\(APIConstants.Collective.authBaseURL)Dashboard/GetHolidayCalenderPdf", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            print(response.data ?? "")
            
            
             let pdfData = Data(response.data!)

            DispatchQueue.main.async {

                let fileManager = FileManager.default

                let resDocPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!

                let pdfFileName = "WMS Calender.pdf"

                let destinationURL = resDocPath.appendingPathComponent(pdfFileName)

                do {
                    
                    // Hide Loader
                   // self.loader.removeLoader(view: self.view)
                    self.hideIndicator()
                 //   ActivityLoader.shared.hideLoader()

                    try pdfData.write(to: destinationURL, options: .atomic)

                    print("File Saved")
                    
                  //  self.showMessageForSomeTime("File Saved", completion: {
                       // DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                    DispatchQueue.main.async {

                            let documentController = UIDocumentInteractionController(url: destinationURL)

                            documentController.delegate = self

                            documentController.presentPreview(animated: true)

                        }
                            
                        //}
                   // })

                } catch {

                    print("Error saving file: \(error.localizedDescription)")

                }

            }
            
        }
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
