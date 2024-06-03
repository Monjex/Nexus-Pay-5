//
//  ApplyRequestServices.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 14/06/23.
//

import Foundation
import Alamofire

class ApplyRequestServices {
    
    public class func applyLeaveRequest(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.applyrequest(ApplyRequestRouter.applyLeaveRequest(body))) { (response) in
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
    
    public class func applyOvertimeRequest(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.applyrequest(ApplyRequestRouter.applyOvertimeRequest(body))) { (response) in
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
    
    public class func getLeaveDaysRequest(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.applyrequest(ApplyRequestRouter.getLeaveDays(body))) { (response) in
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
    
    public class func applyManagerWFHRequest(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.applyrequest(ApplyRequestRouter.managerApplyWFHRequest(body))) { (response) in
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
    
    public class func getManagerLeaveDaysRequest(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.applyrequest(ApplyRequestRouter.getManagerLeaveDays(body))) { (response) in
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
