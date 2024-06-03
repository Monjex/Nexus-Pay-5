//
//  DashboardViewModel.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation

class dashboardViewModel: BaseViewModel {
    
    var year : Int?
    
    var month : Int?
    
    var status : String?
    
    var type : String?
    
    var fromDate : String?
    
    var guid : String?
    
    //new code for all
    var guidforall : [String]?
    
    var reason : String?
    
    var apiStatus : Int?
    
    var access_token : String?
    
    var refresh_token : String?
    
    var leaveType : String?
    
    var empId : String?
    
    var notiId : String?
    
    var notiCount : Int?
    
    var empid : Int?
    
    var leaveBalanceListArr : [leaveBalanceList]?
    
    var managerSummaryListArr : [managerSummaryList]?
    
    var calenderBalanceListArr : [leaveCalenderList]?
    
    var leaveSummaryListArr : [leaveSummaryList]?
    
    var holidayListArr : [holidayList]?
    
    var notificationsListArr : [notificationsList]?
    
    var summaryDetails : LeaveDetails?
    
    var managerUpcomingLeaveBalanceListArr : [leaveBalanceList]?
    
    var callGetDashboardListingService: Bool? {
        didSet {
            dashboardListingService()
        }
    }
    
    var callGetLeaveSummaryListingService: Bool? {
        didSet {
            leaveSummaryListingService()
        }
    }
    
    
    var callGetLeaveSummaryDetailService: Bool? {
        didSet {
            leaveSummaryDetailService()
        }
    }
    
    var callGetHolidayListListingService: Bool? {
        didSet {
            companyHolidayListingService()
        }
    }
    
    var callGetNotificationsListListingService: Bool? {
        didSet {
            notificationsListingService()
        }
    }
    
    var callRefreshTokenService: Bool? {
        didSet {
            refreshTokenService()
        }
    }
    
    var callChangeLeaveStatusService: Bool? {
        didSet {
            changeLeaveStatusService()
        }
    }
    
    //new code for all
    var callChangeLeaveStatusServiceAll: Bool? {
        didSet {
            changeLeaveStatusServiceAll()
        }
    }
    
    var callGetManagerListingListingService: Bool? {
        didSet {
            managerSummaryListingService()
        }
    }
    
    var callGetManagerUpcomingSummaryListingListingService: Bool? {
        didSet {
            managerUpcomingLeaveSummaryListingService()
        }
    }
    
    var callGetManagerSummaryByDateListingListingService: Bool? {
        didSet {
            managerLeaveSummaryByDateListingService()
        }
    }
    
    
    private func dashboardListingService() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let year = year{
            requestBody["Year"] = year
        }
        
        if let month = month{
            requestBody["Month"] = month
        }
        
        
        DashboardServices.dashboardListing(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = HomeListResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    self.leaveBalanceListArr = response.user?.leaveBalanceModels
                    self.calenderBalanceListArr = response.user?.leaveCalenderModels
                    
                    self.notiCount = response.user?.notificationCount
                    
                    self.responseRecieved?()
                }
                else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
                }
               
                else{
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
    
    
    private func leaveSummaryListingService() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let type = type{
            requestBody["LeaveType"] = type
        }
        
        if let status = status{
            requestBody["Status"] = status
        }
        
        if let fromDate = fromDate{
            requestBody["FromDate"] = fromDate
        }
        
        
        DashboardServices.leaveSummaryListing(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = LeaveSummaryListResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    self.leaveSummaryListArr = response.user?.LeaveSummary
                    
                    //self.appliedLeaveData = response.data!
                    self.responseRecieved?()
                }
                else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
                }
                else{
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
    
    
    private func leaveSummaryDetailService() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let guid = guid{
            requestBody["LeaveGUID"] = guid
        }
        
        if let notiid = notiId{
            requestBody["noficationGuid"] = notiid
        }
       
        DashboardServices.leaveSummaryDetail(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = LeaveSummaryDetailResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    
                    self.summaryDetails = response.data
                    
                    //self.appliedLeaveData = response.data!
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
    
    private func companyHolidayListingService() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        DashboardServices.holidayList(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = HolidayListResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    self.holidayListArr = response.user
                    
                    //self.appliedLeaveData = response.data!
                    self.apiStatus = response.statusCode
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
                    self.responseRecieved?()
                   // self.alertMessage = response.message
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
    
    
    private func changeLeaveStatusService() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let guid = guid{
            requestBody["Guid"] = guid
        }
        
        if let status = status{
            requestBody["Status"] = status
        }
        
        if let reason = reason{
            requestBody["Reason"] = reason
        }
        
        
        DashboardServices.changeLeaveStatus(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = LoginResponse(JSON:responseJson!){
                if response.statusCode == 200{
                   
                    self.responseMessage = response.message ?? ""
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
    
    //new code for all
    private func changeLeaveStatusServiceAll() {
        self.isLoading = true
        
        var requestBody = guidforall!
        
        
        DashboardServices.changeLeaveStatusAll(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = LoginResponse(JSON:responseJson!){
                if response.statusCode == 200{
                   
                    self.responseMessage = response.message ?? ""
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
    
    
    private func managerSummaryListingService() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let leaveType = leaveType{
            requestBody["LeaveType"] = leaveType
        }
        
        if let empid = empid{
            requestBody["employeeId"] = empid
        }
        
        
        DashboardServices.managerSummaryListing(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = ManagerSummaryListResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    self.managerSummaryListArr = response.user?.managerSummaryModels
                   
                    self.responseRecieved?()
                }
                else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
                }
               
                else{
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
    
    
    private func managerUpcomingLeaveSummaryListingService() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let leaveType = type{
            requestBody["LeaveType"] = leaveType
        }
        
        if let status = status{
            requestBody["Status"] = status
        }
        
        if let fromDate = fromDate{
            requestBody["FromDate"] = fromDate
        }
        
        if let empId = empId{
            requestBody["employeeId"] = empId
        }
        
        
        DashboardServices.managerUpcomingLeaveSummaryListing(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = ManagerSummaryListResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    self.managerSummaryListArr = response.user?.managerSummaryModels
                   
                    
                    self.responseRecieved?()
                }
                else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
                }
               
                else{
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
    
    
    private func managerLeaveSummaryByDateListingService() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        
        if let fromDate = fromDate{
            requestBody["leaveDate"] = fromDate
        }
        
      
        DashboardServices.managerLeaveSummaryByDateListing(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = ManagerSummaryListResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    self.managerSummaryListArr = response.user?.managerSummaryModels
                   
                    
                    self.responseRecieved?()
                }
                else if response.statusCode == 401{
                    self.apiStatus = response.statusCode
                    self.responseRecieved?()
                }
               
                else{
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
    
    
    private func notificationsListingService() {
        self.isLoading = true
        
        var requestBody = [String:Any]()
        
        DashboardServices.notificationsList(requestBody){ (responseJson) in
            self.isLoading = false
            if let response = NotificationsListResponse(JSON:responseJson!){
                if response.statusCode == 200{
                    self.notificationsListArr = response.user?.notificationsModels
                    
                    //self.appliedLeaveData = response.data!
                    self.apiStatus = response.statusCode
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
    
    
}
