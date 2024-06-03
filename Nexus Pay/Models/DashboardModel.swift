//
//  DashboardModel.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import ObjectMapper

class HomeListResponse : BaseResponse {
    var user : HomeListData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        user <- map["Data"]
    }
}

struct HomeListData : Mappable {
    var leaveBalanceModels : [leaveBalanceList]?
    var leaveCalenderModels : [leaveCalenderList]?
    
    var notificationCount : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        leaveBalanceModels <- map["leaveBalanceModels"]
        leaveCalenderModels <- map["leaveCalenderModels"]
        notificationCount <- map["notificationCount"]
        
    }

}


struct leaveBalanceList : Mappable {
    var Availed : Double?
    var Balance : Double?
    var CarryForwarded : Int?
    var Granted : Double?
    var LeaveAbbreviation : String?
    var LeaveType : String?
    var LeaveTypeID : Int?
   
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        Availed <- map["Availed"]
        Balance <- map["Balance"]
        CarryForwarded <- map["CarryForwarded"]
        Granted <- map["Granted"]
        LeaveAbbreviation <- map["LeaveAbbreviation"]
        LeaveType <- map["LeaveType"]
        LeaveTypeID <- map["LeaveTypeID"]
        
    }

}

struct leaveCalenderList : Mappable {
    var Date : String?
    var DateNumber : Int?
    var LeaveAbbreviation : String?
    var LeaveCategory : String?
    var LeaveType : String?
    var LeaveTypeID : Int?
    var NoOfDays : String?
    var RequestStatus : String?
   
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        Date <- map["Date"]
        DateNumber <- map["DateNumber"]
        LeaveAbbreviation <- map["LeaveAbbreviation"]
        LeaveCategory <- map["LeaveCategory"]
        LeaveType <- map["LeaveType"]
        LeaveTypeID <- map["LeaveTypeID"]
        NoOfDays <- map["NoOfDays"]
        RequestStatus <- map["RequestStatus"]
        
        
    }

}

class LeaveSummaryListResponse : BaseResponse {
    var user : LeaveSummaryListData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        user <- map["Data"]
    }
}

struct LeaveSummaryListData : Mappable {
    var LeaveSummary : [leaveSummaryList]?
    
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        LeaveSummary <- map["LeaveSummary"]
        
    }

}

struct leaveSummaryList : Mappable {
    var LeaveType : String?
    var LeaveDay : String?
    var LeaveStatus : String?
    var Guid : String?
   
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        LeaveType <- map["LeaveType"]
        LeaveDay <- map["LeaveDay"]
        LeaveStatus <- map["LeaveStatus"]
        Guid <- map["Guid"]
        
    }

}


class HolidayListResponse : BaseResponse {
    var user : [holidayList]?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        user <- map["Data"]
    }
}

struct holidayList : Mappable {
    var HolidayType : String?
    var Holiday : String?
    var Day : String?
    var Date : String?
    var IsDisabled : Bool?
   
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        HolidayType <- map["HolidayType"]
        Holiday <- map["Holiday"]
        Day <- map["Day"]
        Date <- map["Date"]
        IsDisabled <- map["IsDisabled"]
        
        
    }

}





class LeaveSummaryDetailResponse : BaseResponse {
    
    var data : LeaveDetails?
    
    required init?(map: Map) {
        super.init(map: map)
    }
       
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["Data"]
    }

}

struct LeaveDetails : Mappable {
    var LeaveSummaryDetailId : String?
    var EmployeeId : Int?
    var LeaveTypeID : Int?
    var LeaveType : String?
    var LeaveCategory : String?
    var NoOfDays : Double?
    var FromDate : String?
    var ToDate : String?
    var FromSession : String?
    var ToSession : String?
    var RequestStatus : String?
    var ApproverId : Int?
    var ApproverName : String?
    var AppliedOn : String?
    var Reason : String?
    
    var CL : NSDictionary?
    var CO : NSDictionary?
    var EL : NSDictionary?
    var RH : NSDictionary?
    var SL : NSDictionary?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        LeaveSummaryDetailId <- map["LeaveSummaryDetailId"]
        EmployeeId <- map["EmployeeId"]
        LeaveTypeID <- map["LeaveTypeID"]
        LeaveType <- map["LeaveType"]
        LeaveCategory <- map["LeaveCategory"]
        NoOfDays <- map["NoOfDays"]
        FromDate <- map["FromDate"]
        ToDate <- map["ToDate"]
        FromSession <- map["FromSession"]
        ToSession <- map["ToSession"]
        RequestStatus <- map["RequestStatus"]
        ApproverId <- map["ApproverId"]
        ApproverName <- map["ApproverName"]
        AppliedOn <- map["AppliedOn"]
        Reason <- map["Reason"]
        
        CL <- map["CL"]
        CO <- map["CO"]
        EL <- map["EL"]
        RH <- map["RH"]
        SL <- map["SL"]
        
    }
}

class ManagerSummaryListResponse : BaseResponse {
    var user : ManagerSummaryListData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        user <- map["Data"]
    }
}

struct ManagerSummaryListData : Mappable {
    var managerSummaryModels : [managerSummaryList]?
    

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        managerSummaryModels <- map["LeaveSummary"]
        
    }

}


struct managerSummaryList : Mappable {
    var EmployeeId : Int?
    var EmployeeName : String?
    var Guid : String?
    var LeaveDay : String?
    var LeaveStatus : String?
    var LeaveType : String?
    var LeaveCategory : String?
    var isSelected = false
   
    init?(map: Map) {

    }
    
    mutating func changeValue(withNewValue value: Bool) {
            self.isSelected = value
        }

    mutating func mapping(map: Map) {

        EmployeeId <- map["EmployeeId"]
        EmployeeName <- map["EmployeeName"]
        Guid <- map["Guid"]
        LeaveDay <- map["LeaveDay"]
        LeaveStatus <- map["LeaveStatus"]
        LeaveType <- map["LeaveType"]
        LeaveCategory <- map["LeaveCategory"]
        
    }

}

class NotificationsListResponse : BaseResponse {
    var user : NotificationsListData?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        user <- map["Data"]
    }
}

struct NotificationsListData : Mappable {
    var notificationsModels : [notificationsList]?
    

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        notificationsModels <- map["NotificationList"]
        
    }

}


struct notificationsList : Mappable {
    var EmployeeId : Int?
    var IsNotificationView : Bool?
    var Leave_Guid : String?
    var Notification : String?
    var NotificationDate : String?
    var NotificationGuid : String?
    var Sender : String?
    var Time : String?
    var IsManagerView : Bool?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        EmployeeId <- map["EmployeeId"]
        IsNotificationView <- map["IsNotificationView"]
        Leave_Guid <- map["Leave_Guid"]
        Notification <- map["Notification"]
        NotificationDate <- map["NotificationDate"]
        NotificationGuid <- map["NotificationGuid"]
        Sender <- map["Sender"]
        Time <- map["Time"]
        IsManagerView <- map["IsManagerView"]
        
    }
    
    
}
