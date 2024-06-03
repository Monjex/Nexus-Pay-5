//
//  UserServices.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import Alamofire

class UserServices {
    
    public class func login(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.userRouterManager(UserRouter.login(body))) { (response) in
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
    
    public class func otp(_ body: RequestBody,successCallback: @escaping ((_ response: JSON?) -> Void) , errorCallback: @escaping ((_ error : Error) -> Void), networkErrorCallback:@escaping (()->Void)){
        NetworkAdapter.request(GeneralBaseRouter.userRouterManager(UserRouter.otp(body))) { (response) in
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
