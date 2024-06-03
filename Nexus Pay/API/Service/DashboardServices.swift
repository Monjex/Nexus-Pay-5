//
//  DashboardServices.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import Alamofire

class DashboardServices {
    
    public class func dashboardListing(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.dashboard(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    public class func leaveSummaryListing(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.leaveSummary(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    public class func leaveSummaryDetail(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.leaveSummaryDetail(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    public class func holidayList(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.holidayList(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    public class func refreshToken(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.refreshToken(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    public class func changeLeaveStatus(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.changeLeaveStatus(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    //new code for all
    public class func changeLeaveStatusAll(_ body: RequestBodyAll,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.changeLeaveStatusAll(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    public class func managerSummaryListing(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.managerSummary(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    public class func managerUpcomingLeaveSummaryListing(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.managerUpcomingLeaveSummary(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    public class func managerLeaveSummaryByDateListing(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.managerSummaryByDate(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
    
    public class func notificationsList(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.dashboardRouterManager(DashboardRouter.notificationsList(body))) { (response) in
            print(response)
            if let responseJSON = response as? JSON{
                successCallback(responseJSON)
            }else{
                errorCallback(APIError.parseError)
            }
        } errorHandler: { (error) in
            errorCallback(error)
        } networkErrorHandler: {
            networkErrorCallback()
        }
    }
}
