//
//  ApplyRequestViewModel.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 14/06/23.
//

import Foundation

class ApplyRequestViewModel: BaseViewModel {
    
    var ID : Int?
    
    var userId : Int?
    
    var languageId : Int?
    
    //var userDetails : UserDetails?
    
    var email : String?
    
    var name : String?
    
    var leaveType : String?
    
    var startDate : String?
    
    var endDate : String?
    
    var startSession : String?
    
    var endSession : String?
    
    var mobileNumber : String?
    
    var applyingTo : String?
    
    var managerEmail : String?
    
    var ccmanagerEmail : String?
    
    var remarks : String?
    
    var workLocation: String?
    
    var isOvertime: Bool?
    
    var leaveDays : LeaveDays?
    
    var apiStatus : Int?
    
    var access_token : String?
    
    var refresh_token : String?
    
    var timezone : String?
    
    var applyingName : String?
    
    var applyingId : Int?
    
    var applyingEmail : String?
    
    //new code for half day
    var isHalfDay : Bool?
    
    var callApplyLeaveService: Bool? {
        didSet {
            applyLeave()
        }
    }
    
    var callApplyOvertimeService: Bool? {
        didSet {
            applyOvertime()
        }
    }
    
    var callGetLeaveDaysService: Bool? {
        didSet {
            getLeaveDays()
        }
    }
    
    var callGetManagerLeaveDaysService: Bool? {
        didSet {
            getManagerLeaveDays()
        }
    }
    
    var callRefreshTokenService: Bool? {
        didSet {
            refreshTokenService()
        }
    }
    
    var callManagerApplyWFHService: Bool? {
        didSet {
            managerApplyWFH()
        }
    }
    
    
    private func applyLeave() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let leaveType = leaveType{
            requestBody["LeaveType"] = leaveType
        }
        
        if let startDate = startDate{
            requestBody["StartDate"] = startDate
        }
        
        if let endDate = endDate{
            requestBody["EndDate"] = endDate
        }
        
        if let startSession = startSession{
            requestBody["SessionStart"] = startSession
        }
        
        if let endSession = endSession{
            requestBody["SessionEnd"] = endSession
        }
        
        if let mobileNumber = mobileNumber{
            requestBody["MobileNumber"] = mobileNumber
        }
        
        if let applyingTo = applyingTo{
            requestBody["ApplyTo"] = applyingTo
        }
        
        if let managerEmail = managerEmail{
            requestBody["ManagerEmail"] = managerEmail
        }
        
        if let ccmanagerEmail = ccmanagerEmail{
            requestBody["CcManagerEmail"] = ccmanagerEmail
        }
        
        if let remarks = remarks{
            requestBody["Remarks"] = remarks
        }
        
        if let workLocation = workLocation{
            requestBody["WorkLocation"] = workLocation
        }
        
        if let timezone = timezone{
            requestBody["TimeZone"] = timezone
        }
        
        if let isHalfDay = isHalfDay{
            requestBody["IsHalfday"] = isHalfDay
        }
        
        
        ApplyRequestServices.applyLeaveRequest(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = ApplyLeaveResponse(JSON:responseJson!){
                if response.statusCode == 200{
                   // if let userData = response.user{
                       // AuthUtils.setLoginUserData(userData: userData)
                      //  print(AuthUtils.getUserId())
                        self.responseMessage = response.message ?? ""
                        self.responseRecieved?()
//                    }else{
//                        self.alertMessage = "You are not valid user."
//                    }
                }else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
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
    
    
    private func applyOvertime() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let leaveType = leaveType{
            requestBody["LeaveType"] = leaveType
        }
        
        if let startDate = startDate{
            requestBody["StartDate"] = startDate
        }
        
        if let endDate = endDate{
            requestBody["EndDate"] = endDate
        }
        
        if let startSession = startSession{
            requestBody["SessionStart"] = startSession
        }
        
        if let endSession = endSession{
            requestBody["SessionEnd"] = endSession
        }
        
        if let mobileNumber = mobileNumber{
            requestBody["MobileNumber"] = mobileNumber
        }
        
        if let applyingTo = applyingTo{
            requestBody["ApplyTo"] = applyingTo
        }
        
        if let managerEmail = managerEmail{
            requestBody["ManagerEmail"] = managerEmail
        }
        
        if let ccmanagerEmail = ccmanagerEmail{
            requestBody["CcManagerEmail"] = ccmanagerEmail
        }
        
        if let remarks = remarks{
            requestBody["Remarks"] = remarks
        }
        
        if let workLocation = workLocation{
            requestBody["WorkLocation"] = workLocation
        }
        
        if let timezone = timezone{
            requestBody["TimeZone"] = timezone
        }
        
        
        ApplyRequestServices.applyOvertimeRequest(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = ApplyLeaveResponse(JSON:responseJson!){
                if response.statusCode == 200{
                   // if let userData = response.user{
                       // AuthUtils.setLoginUserData(userData: userData)
                      //  print(AuthUtils.getUserId())
                        self.responseMessage = response.message ?? ""
                        self.responseRecieved?()
//                    }else{
//                        self.alertMessage = "You are not valid user."
//                    }
                }else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
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
    
    
    private func getLeaveDays() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let leaveType = leaveType{
            requestBody["LeaveType"] = leaveType
        }
        
        if let startDate = startDate{
            requestBody["StartDate"] = startDate
        }
        
        if let endDate = endDate{
            requestBody["EndDate"] = endDate
        }
        
        if let startSession = startSession{
            requestBody["SessionStart"] = startSession
        }
        
        if let endSession = endSession{
            requestBody["SessionEnd"] = endSession
        }
        
        if let isOvertime = isOvertime{
            requestBody["IsOverTime"] = isOvertime
        }
        
        if let timezone = timezone{
            requestBody["TimeZone"] = timezone
        }
        
        if let isHalfDay = isHalfDay{
            requestBody["IsHalfday"] = isHalfDay
        }
        
        ApplyRequestServices.getLeaveDaysRequest(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = GetLeaveDaysResponse(JSON:responseJson!){
                if response.statusCode == 200{
                   
                    self.leaveDays = response.data
                    self.responseRecieved?()

                }else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
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
    
    
    private func refreshTokenService() {
        
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
       // if let otp = otpString{
        requestBody["Access_Token"] = "Bearer \(AuthUtils.getAuthToken() ?? "")"
       // }
        
       // if let emailid = email{
        requestBody["Refresh_Token"] = AuthUtils.getRefreshToken()
        //}
        
        
        DashboardServices.refreshToken(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = LoginResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    if let userData = response.user{
                        AuthUtils.setLoginUserData(userData: userData)
                       // print(AuthUtils.getAuthToken())
                       // self.responseMessage = response.message ?? ""
                        self.apiStatus = response.statusCode
                        self.responseRecieved?()
                    }else{
                        self.alertMessage = "You are not valid user."
                    }
                }else{
                    //self.alertMessage = response.message
                    self.responseRecieved?()
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
    
    
    
    private func managerApplyWFH() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let leaveType = leaveType{
            requestBody["LeaveType"] = leaveType
        }
        
        if let startDate = startDate{
            requestBody["StartDate"] = startDate
        }
        
        if let endDate = endDate{
            requestBody["EndDate"] = endDate
        }
        
        if let startSession = startSession{
            requestBody["SessionStart"] = startSession
        }
        
        if let endSession = endSession{
            requestBody["SessionEnd"] = endSession
        }
        
        if let applyingTo = applyingEmail{
            requestBody["ApplyForEmail"] = applyingTo
        }
        
        if let applyingTo = applyingId{
            requestBody["ApplyForId"] = applyingTo
        }
        
        if let applyingTo = applyingName{
            requestBody["ApplyForName"] = applyingTo
        }
        
        if let managerEmail = managerEmail{
            requestBody["ManagerEmail"] = managerEmail
        }
        
        if let ccmanagerEmail = ccmanagerEmail{
            requestBody["CcManagerEmail"] = ccmanagerEmail
        }
        
        if let remarks = remarks{
            requestBody["Remarks"] = remarks
        }
        
        if let timezone = timezone{
            requestBody["TimeZone"] = timezone
        }
        
        
        ApplyRequestServices.applyManagerWFHRequest(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = ApplyLeaveResponse(JSON:responseJson!){
                if response.statusCode == 200{
                   // if let userData = response.user{
                       // AuthUtils.setLoginUserData(userData: userData)
                      //  print(AuthUtils.getUserId())
                        self.responseMessage = response.message ?? ""
                        self.responseRecieved?()
//                    }else{
//                        self.alertMessage = "You are not valid user."
//                    }
                }else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
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
    
    
    private func getManagerLeaveDays() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        if let applyingId = applyingId{
            requestBody["EmployeeId"] = applyingId
        }
        
        if let leaveType = leaveType{
            requestBody["LeaveType"] = leaveType
        }
        
        if let startDate = startDate{
            requestBody["StartDate"] = startDate
        }
        
        if let endDate = endDate{
            requestBody["EndDate"] = endDate
        }
        
        if let startSession = startSession{
            requestBody["SessionStart"] = startSession
        }
        
        if let endSession = endSession{
            requestBody["SessionEnd"] = endSession
        }
        
        if let isOvertime = isOvertime{
            requestBody["IsOverTime"] = isOvertime
        }
        
        if let timezone = timezone{
            requestBody["TimeZone"] = timezone
        }
        
//        if let timezone = timezone{
//            requestBody["Remarks"] = timezone
//        }
//
       // if let timezone = timezone{
            requestBody["IsManager"] = true
        //}
        
        ApplyRequestServices.getManagerLeaveDaysRequest(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = GetLeaveDaysResponse(JSON:responseJson!){
                if response.statusCode == 200{
                   
                    self.leaveDays = response.data
                    self.responseRecieved?()

                }else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
                }else{
                    self.alertMessage = response.message
                    self.responseRecieved?()
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
