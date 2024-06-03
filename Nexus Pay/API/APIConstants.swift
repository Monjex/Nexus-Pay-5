//
//  APIConstants.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Foundation

/**
 *  API String Constants Defining BaseURL and Other API URL Paths.
 */
public struct APIConstants {

    struct Temp {
        static let source = "App"
        static let teacherRole = "teacher"
    }
    
    
    struct Collective {
        
        
       static let authBaseURL = "http://wms.tglserver.net/api/"
        
        //static let authBaseURL = "https://wmsmobileapp.tglserver.net/api/"
        
        //http://192.168.10.168:85/swagger/index.html
        
       // static let authBaseURL = "http://192.168.10.168:85/api/"
        
        static let baseURL = ""//Config.Collective.baseURL
      //  static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQiLCJuYmYiOjE2MzQxMDc1ODQsImV4cCI6MTYzNDE5Mzk4NCwiaWF0IjoxNjM0MTA3NTg0fQ.uk0P1yfVUBC35O1TcBduuiCj2gCW1j3zlnQ16QulGJY"//Config.Collective.token
        
        
        //static let getParentLeaveTypes = "/api/VacationManagement/get-parent-leavetypes"
        
        static let login = "Login/SendOTPToEmail"
        
        static let otp = "Login/VerifyOTP"
        
        static let refreshToken = "Login/refreshtoken"
        
        static let dashboard = "Dashboard/GetCalenderHolidayAndLeaveList"
        
        static let leaveSummary = "ApplyRequest/GetLeaveSummaryList"
        
        static let changeleaveStatus = "ApplyRequest/ChangeLeaveStatus"
        
        //new code for all
        static let changeleaveStatusAll = "ApplyRequest/ChangeLeaveStatusInBulk"
        
        static let leaveSummaryDetail = "ApplyRequest/GetLeaveSummaryDetail"
        
        static let applyLeave = "ApplyRequest/ApplyLeave"
        
        static let managerApplyWFH = "ApplyRequest/ManagerApplyLeave"
        
        static let applyOvertime = "ApplyRequest/ApplyOverTime"
        
        static let holidayList = "ApplyRequest/GetHolidayList"
        
        static let getLeaveDays = "ApplyRequest/GetLeaveDays"
        
        static let getManagerLeaveDays = "ApplyRequest/GetManagerLeaveDays"
        
        static let managerLeaveSummary = "ApplyRequest/GetManagerLeaveSummaryList"
        
        static let managerUpcomingLeaveSummary = "ApplyRequest/GetManagerTeamUpcomingLeaveSummary"
        
        static let managerLeaveSummaryByDate = "ApplyRequest/GetLeaveSummaryByDate"
        
        static let notificationsList = "ApplyRequest/GetUserNotification"
        
        
    }
}
