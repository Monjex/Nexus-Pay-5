//
//  BaseResponse.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import ObjectMapper

class BaseResponse : Mappable {
    
    
    var statusCode : Int?
    var message : String?
    var errors : [String]?
    
    
    required init?(map: Map) {
        
    }
    

    func mapping(map: Map) {

        statusCode <- map["StatusCode"]
        message <- map["Message"]
        errors <- map["Errors"]
        
    }

}



class LoginResponse : BaseResponse {
    var user : User?
    
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


class OtpResponse : BaseResponse {
    var user : User?
    
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


