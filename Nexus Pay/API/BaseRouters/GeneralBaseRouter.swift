//
//  GeneralBaseRouter.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import Alamofire
import ObjectMapper

enum GeneralBaseRouter: URLRequestConvertible {
    
    case userRouterManager(UserRouter)
    case dashboardRouterManager(DashboardRouter)
    case applyrequest(ApplyRequestRouter)
//    case notificationsRouterManager(NotificationsRouter)
//    case addressRouterManager(AddressRouter)
//    case cartRouterManager(CartRouter)
//    case checkoutRouterManager(CheckoutRouter)
   
    func asURLRequest() throws -> URLRequest {
        switch self {
       
        case .userRouterManager(let request):
            let mutableURLRequest = configureRequest(request)
            return mutableURLRequest
            
        case .dashboardRouterManager(let request):
            let mutableURLRequest = configureRequest(request)
            return mutableURLRequest

        case .applyrequest(let request):
            let mutableURLRequest = configureRequest(request)
            return mutableURLRequest
//
//        case .notificationsRouterManager(let request):
//            let mutableURLRequest = configureRequest(request)
//            return mutableURLRequest
//
//        case .addressRouterManager(let request):
//            let mutableURLRequest = configureRequest(request)
//            return mutableURLRequest
//
//        case .cartRouterManager(let request):
//            let mutableURLRequest = configureRequest(request)
//            return mutableURLRequest
//
//        case .checkoutRouterManager(let request):
//            let mutableURLRequest = configureRequest(request)
//            return mutableURLRequest
       
        }
    }
    
    /**
     Configuring Request for each of the cases.
     
     - parameter requestObj: An Object of the Router Protocol.
     - Contains Path of the Request.
     - Contains Method GET, POST, PUT
     - Contains Request Parameters
     - Contains Request Body
     
     - returns: <#return value description#>
     */
    
    func configureRequest(_ requestObj: BaseRouterProtocol) -> URLRequest {
        
        let url = URL(string: APIConstants.Collective.authBaseURL)!

        /// Set Request Path
        var mutableURLRequest = URLRequest(url: url.appendingPathComponent(requestObj.path))
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /**
         *  Set Request Method
         */
        mutableURLRequest.httpMethod = requestObj.method.rawValue
        
        //Set Request Headers
        
        //Common headers
       // mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //mutableURLRequest.setValue(HeaderConstants.application, forHTTPHeaderField: "X-Application")
        
        //Specific headers
        if let headers = requestObj.headers {
            for (key, value) in headers {
                mutableURLRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        /**
         *  Set Request Body if Method is POST or PUT
         */
        if requestObj.method == Alamofire.HTTPMethod.post || requestObj.method == Alamofire.HTTPMethod.get || requestObj.method == Alamofire.HTTPMethod.put {
            if let body = requestObj.body {
                if let mappableBody = body as? Mappable {
                    mutableURLRequest.httpBody = mappableBody.toJSONString()?.data(using: String.Encoding.utf8)
                } else {
                    if JSONSerialization.isValidJSONObject(body) {
                        do {
                            mutableURLRequest.httpBody =
                                try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
                        } catch {
                        }
                    }
                }
            }
        }
        //// Set Request Parameters.
        if let parameters: Alamofire.Parameters = requestObj.parameters {
            do {
                return try Alamofire.URLEncoding.queryString.encode(mutableURLRequest as URLRequestConvertible, with: parameters)
            } catch {
            }
        }
        return mutableURLRequest
    }
}
