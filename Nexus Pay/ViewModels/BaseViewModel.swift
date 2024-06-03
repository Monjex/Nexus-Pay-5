//
//  BaseViewModel.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation

class BaseViewModel {
    // MARK: - Variables
    
    var responseMessage: String?
    
   // var is_applied: Bool?
    
    // MARK: - Variables
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var showEmptyMsg: Bool? {
        didSet {
            showEmptyMsgClausre?()
        }
    }
    
    var isEndRefresh: Bool? {
        didSet {
            endRefreshClausre?()
        }
    }
    
    var showNoInternetScreen: Bool? {
        didSet {
            showNoInternetView?(showNoInternetScreen ?? false)
        }
    }
    
    // MARK: - Clausers
    
    var endRefreshClausre: (() -> ())?
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var reloadTableViewClosure: (() -> ())?
    var showEmptyMsgClausre: (() -> ())?
    var showNoInternetView: ((Bool) -> ())?
    var responseRecieved: (() -> ())?
    var readAllResponseRecieved: (() -> ())?
    var updateUploadingStatusVideos: ((Bool, NSDictionary?) -> ())?
    var UploadingVideosClosure: (() -> ())?
    var logout: (() -> ())?
    
    init() {}
}
/*
func testMethod() {
    let viewModel = LoginViewModel()
    
    // For Loading Indicator
    viewModel.updateLoadingStatus = { [weak self] () in
        guard self != nil else { return }
        DispatchQueue.main.async {
            if viewModel.isLoading {
                SharedInstance.shared.showLoader()
            } else {
                SharedInstance.shared.hideLoader()
            }
        }
    }
    
    // For Alert message
    viewModel.showAlertClosure = { [weak self] () in
        guard let self = self else { return }
        DispatchQueue.main.async {
            if let message = viewModel.alertMessage {
                self.showAlert(self, message: message)
            }
        }
    }
    
    // Response recieved
    viewModel.responseRecieved = { [weak self] in
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.showAlert(self, message: "Logged in successfully")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let getStarted = Router.viewController(with: .getStarted, and: .main)
                self.pushVC(getStarted)
            }
        }
    }
    
    viewModel.email = self.email_TF.text
    viewModel.password = self.password_TF.text
    viewModel.callLoginService = true
}
*/
