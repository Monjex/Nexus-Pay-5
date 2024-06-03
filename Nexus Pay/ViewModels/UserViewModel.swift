//
//  UserViewModel.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation


class UserViewModel: BaseViewModel {
    
    var ID : Int?
    
    var userId : Int?
    
    var languageId : Int?
    
    //var userDetails : UserDetails?
    
    var email : String?
    
    var name : String?
    
    var adToken : String?
    
    var deviceToken : String?
    
    var deviceType : String?
    
    var appVersion : String?
    
    var otpString : String?
    
    var FirebaseDeviceToken : String?
    
    
    var callLoginService: Bool? {
        didSet {
            login()
        }
    }
    
    
    var callOtpService: Bool? {
        didSet {
            otp()
        }
    }
    
    
    private func login() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let email = email{
            requestBody["EmailId"] = email
        }
        
        
        UserServices.login(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = LoginResponse(JSON:responseJson!){
                if response.statusCode == 200{
                   // if let userData = response.user{
                       // AuthUtils.setLoginUserData(userData: userData)
                      //  print(AuthUtils.getUserId())
                        self.responseMessage = response.message ?? ""
                        self.responseRecieved?()
//                    }else{
//                        self.alertMessage = "You are not valid user."
//                    }
                }else{
                    self.alertMessage = response.message
                }
            }else{
                self.alertMessage = APIError.parseError.description
            }
        } errorCallback: { (error) in
            self.isLoading = false
            self.alertMessage = error.localizedDescription
        } networkErrorCallback: {
            self.isLoading = false
            self.alertMessage = AlertMessages.networkError
        }

    }
    
    
    private func otp() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let otp = otpString{
            requestBody["OTP"] = otp
        }
        
        if let emailid = email{
            requestBody["EmailId"] = emailid
        }
        
        if let FirebaseDeviceToken = FirebaseDeviceToken{
            requestBody["FirebaseDeviceToken"] = FirebaseDeviceToken
        }
        
        requestBody["IsAndroiodDevice"] = false
        
        
        UserServices.otp(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = LoginResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    
                    if let userData = response.user{
                        AuthUtils.setLoginUserData(userData: userData)
                        
                        print(AuthUtils.getIsManager())
                        
                        UserDefaults.standard.set(AuthUtils.getIsManager(), forKey: "IsManager")
                        
                        UserDefaults.standard.set(AuthUtils.getOfficeLocation(), forKey: "OfficeLocation")
                        
                       // print(AuthUtils.getAuthToken())
                       // self.responseMessage = response.message ?? ""
                        self.responseRecieved?()
                    }else{
                        self.alertMessage = "You are not valid user."
                    }
                }else{
                    self.alertMessage = response.message
                }
            }else{
                self.alertMessage = APIError.parseError.description
            }
        } errorCallback: { (error) in
            self.isLoading = false
            self.alertMessage = error.localizedDescription
        } networkErrorCallback: {
            self.isLoading = false
            self.alertMessage = AlertMessages.networkError
        }

    }
    
}
