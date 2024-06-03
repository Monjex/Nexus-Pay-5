//
//  APIResponseType.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Foundation

enum APIResponseType {
    
    case success , error
    
    static func fromSlag(statusCode: Int) -> APIResponseType {
        
        if (statusCode == 50000)  || (statusCode >= 200 && statusCode < 300){
            return .success
        }
        
        return .error
    }
    
}
