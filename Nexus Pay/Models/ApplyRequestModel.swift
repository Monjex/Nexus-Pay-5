//
//  ApplyRequestModel.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 14/06/23.
//

import Foundation
import ObjectMapper

class ApplyLeaveResponse : BaseResponse {
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

class GetLeaveDaysResponse : BaseResponse {
    
    var data : LeaveDays?
    
    required init?(map: Map) {
        super.init(map: map)
    }
       
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["Data"]
    }

}

struct LeaveDays : Mappable {
    var Days : String?
    var IsSandwichapplied : Bool?
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        Days <- map["Days"]
        IsSandwichapplied <- map["IsSandwichapplied"]
        
    }
}
