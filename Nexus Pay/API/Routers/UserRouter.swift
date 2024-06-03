//
//  UserRouter.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import Alamofire

enum UserRouter: BaseRouterProtocol {
    
    
    case login(RequestBody)
    case otp(RequestBody)
    
    
    var path: String {
        switch self {
       
        case .login:
            return String.localizedStringWithFormat(APIConstants.Collective.login)
            
        case .otp:
            return String.localizedStringWithFormat(APIConstants.Collective.otp)
            
       
        }
    }
    
    var method: HTTPMethod {
        switch self {
            
        case .login:
            return .post
            
        case .otp:
            return .post
            
        default:
            return .post
      
        }
    }
    
    var parameters: Parameters? {
        switch self {

//        case .getProfile(let params):
//            return params

        default:
            return nil
        }
    }
    
    var body: AnyObject? {
        switch self {
        case .login(let body):
           return body as AnyObject
            
        case .otp(let body):
           return body as AnyObject
            
        default:
            return nil
        
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        case .login:
            return nil
            
        case .otp:
            return nil
            
        default:
            return ["Authorization": "\(AuthUtils.getAuthToken() ?? "")"]
           // return ["Token": ""]
        }
    }
}
