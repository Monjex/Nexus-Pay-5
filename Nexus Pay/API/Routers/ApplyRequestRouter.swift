//
//  ApplyRequestRouter.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 14/06/23.
//

import Foundation
import Alamofire

enum ApplyRequestRouter: BaseRouterProtocol {
    
    
    case applyLeaveRequest(RequestBody)
    case applyOvertimeRequest(RequestBody)
    case getLeaveDays(RequestBody)
    
    case managerApplyWFHRequest(RequestBody)
    case getManagerLeaveDays(RequestBody)
    
    
    var path: String {
        switch self {
       
        case .applyLeaveRequest:
            return String.localizedStringWithFormat(APIConstants.Collective.applyLeave)
            
        case .applyOvertimeRequest:
            return String.localizedStringWithFormat(APIConstants.Collective.applyOvertime)
            
        case .getLeaveDays:
            return String.localizedStringWithFormat(APIConstants.Collective.getLeaveDays)
            
        case .managerApplyWFHRequest:
            return String.localizedStringWithFormat(APIConstants.Collective.managerApplyWFH)
            
        case .getManagerLeaveDays:
            return String.localizedStringWithFormat(APIConstants.Collective.getManagerLeaveDays)
            
        
       
        }
    }
    
    var method: HTTPMethod {
        switch self {
            
        case .applyLeaveRequest:
            return .post
            
        case .applyOvertimeRequest:
            return .post
            
        case .getLeaveDays:
            return .post
            
        case .managerApplyWFHRequest:
            return .post
            
        case .getManagerLeaveDays:
            return .post
            
            
        default:
            return .post
      
        }
    }
    
    var parameters: Parameters? {
        switch self {


        default:
            return nil
        }
    }
    
    var body: AnyObject? {
        switch self {
            
        case .applyLeaveRequest(let body):
           return body as AnyObject
            
        case .applyOvertimeRequest(let body):
           return body as AnyObject
            
        case .getLeaveDays(let body):
           return body as AnyObject
            
        case .managerApplyWFHRequest(let body):
           return body as AnyObject
            
        case .getManagerLeaveDays(let body):
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
