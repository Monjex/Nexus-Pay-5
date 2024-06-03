//
//  LoginModel.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import ObjectMapper
import UIKit


class User : NSObject, Codable, Mappable {
    var userid: Int?
    var userName: String?
    var Name: String?
    var lastName: String?
    //var role: [Role]?
    var accessToken: String?
    var Refresh_token: String?
   // var newAccessToen: String?
    var email : String?
    var mobile : String?
    var langId : Int?
    var otp : Int?
    var is_registration_otp_verified : Bool?
    var is_favorite_toggle_on : Bool?
    var IsManager : Bool?
    var officeLocation : String?
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        userid <- map["UserId"]
        userName <- map["username"]
        Name <- map["Name"]
        lastName <- map["last_name"]
       // role <- map["role"]
        accessToken <- map["Access_Token"]
        Refresh_token <- map["Refresh_Token"]
       // newAccessToen <- map["AccessToken"]
        email <- map["EmailId"]
        mobile <- map["Mobile"]
        langId <- map["languageId"]
        otp <- map["OTP"]
        is_registration_otp_verified <- map["is_registration_otp_verified"]
      //  is_favorite_toggle_on <- map["is_favorite_toggle_on"]
        IsManager <- map["IsManager"]
        officeLocation <- map["OfficeLocation"]  
    }
    
    enum CodingKeys: String, CodingKey {
        case userid
        case userName
        case Name
        case lastName
       // case role
        case accessToken
        case Refresh_token
        case email
        case langId
        case otp
        case mobile
        case is_registration_otp_verified
      //  case is_favorite_toggle_on
        case IsManager
        case officeLocation
    }
}



class CustomerDetailUser : NSObject, Codable, Mappable {
    var userid: Int?
    var userName: String?
    var firstName: String?
    var lastName: String?
    var email : String?
    var mobile : String?
    var last_searched_text : String?
    var address_type : String?
    var langId : Int?
    var otp : Int?
    var is_registration_otp_verified : Bool?
    var is_guest : Bool?
    var is_favorite_toggle_on : Bool?
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        userid <- map["customer_id"]
        userName <- map["username"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        mobile <- map["mobile_number"]
        last_searched_text <- map["last_searched_text"]
        address_type <- map["address_type"]
        langId <- map["languageId"]
        otp <- map["OTP"]
        is_registration_otp_verified <- map["is_registration_otp_verified"]
        is_guest <- map["is_guest"]
        is_favorite_toggle_on <- map["is_favorite_toggle_on"]
    }
    
    enum CodingKeys: String, CodingKey {
        case userid
        case userName
        case firstName
        case lastName
        case email
        case langId
        case otp
        case mobile
        case last_searched_text
        case address_type
        case is_registration_otp_verified
        case is_guest
        case is_favorite_toggle_on
    }
}
