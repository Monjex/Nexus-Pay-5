//
//  DashboardRouter.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import Alamofire

enum DashboardRouter: BaseRouterProtocol {
    
    
    case dashboard(RequestBody)
    case leaveSummary(RequestBody)
    case leaveSummaryDetail(RequestBody)
    case holidayList(RequestBody)
    case refreshToken(RequestBody)
    case changeLeaveStatus(RequestBody)
    
    //new code for all
    case changeLeaveStatusAll(RequestBodyAll)
    
    case managerSummary(RequestBody)
    case managerUpcomingLeaveSummary(RequestBody)
    case managerSummaryByDate(RequestBody)
    
    case notificationsList(RequestBody)
    
    
    var path: String {
        switch self {
       
        case .dashboard:
            return String.localizedStringWithFormat(APIConstants.Collective.dashboard)
            
        case .leaveSummary:
            return String.localizedStringWithFormat(APIConstants.Collective.leaveSummary)
            
        case .leaveSummaryDetail:
            return String.localizedStringWithFormat(APIConstants.Collective.leaveSummaryDetail)
            
        case .holidayList:
            return String.localizedStringWithFormat(APIConstants.Collective.holidayList)
            
        case .refreshToken:
            return String.localizedStringWithFormat(APIConstants.Collective.refreshToken)
            
        case .changeLeaveStatus:
            return String.localizedStringWithFormat(APIConstants.Collective.changeleaveStatus)
         
        //new code for all
        case .changeLeaveStatusAll:
            return String.localizedStringWithFormat(APIConstants.Collective.changeleaveStatusAll)
            
        case .managerSummary:
            return String.localizedStringWithFormat(APIConstants.Collective.managerLeaveSummary)
            
        case .managerUpcomingLeaveSummary:
            return String.localizedStringWithFormat(APIConstants.Collective.managerUpcomingLeaveSummary)
            
        case .managerSummaryByDate:
            return String.localizedStringWithFormat(APIConstants.Collective.managerLeaveSummaryByDate)
            
        case .notificationsList:
            return String.localizedStringWithFormat(APIConstants.Collective.notificationsList)
            
       
        }
    }
    
    var method: HTTPMethod {
        switch self {
            
        case .dashboard:
            return .get
            
        case .leaveSummary:
            return .get
            
        case .leaveSummaryDetail:
            return .get
            
        case .holidayList:
            return .get
            
        case .refreshToken:
            return .post
            
        case .changeLeaveStatus:
            return .post
        
        //new code for all
        case .changeLeaveStatusAll:
            return .post
            
        case .managerSummary:
            return .get
            
        case .managerUpcomingLeaveSummary:
            return .get
            
        case .managerSummaryByDate:
            return .get
            
        case .notificationsList:
            return .get
            
            
        default:
            return .post
      
        }
    }
    
    var parameters: Parameters? {
        switch self {

        case .dashboard(let params):
            return params
            
        case .leaveSummary(let params):
            return params
            
        case .leaveSummaryDetail(let params):
            return params
            
        case .holidayList(let params):
            return params
            
        case .managerSummary(let params):
            return params
            
        case .managerUpcomingLeaveSummary(let params):
            return params
            
        case .managerSummaryByDate(let params):
            return params
            
        case .notificationsList(let params):
            return params

        default:
            return nil
        }
    }
    
    var body: AnyObject? {
        switch self {
            
        case .refreshToken(let body):
           return body as AnyObject
            
        case .changeLeaveStatus(let body):
           return body as AnyObject
       
        //new code for all
        case .changeLeaveStatusAll(let body):
           return body as AnyObject
            
        default:
            return nil
        
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        default:
            return ["Authorization": "Bearer \(AuthUtils.getAuthToken() ?? "")"]
           // return ["Token": ""]
        }
    }
}
