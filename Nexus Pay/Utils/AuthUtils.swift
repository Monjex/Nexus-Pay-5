//
//  AuthUtils.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import ObjectMapper

class AuthUtils {

    public static func getAuthToken() -> String? {
        if let loginUserData = getLoginUserData() {
            return loginUserData.accessToken
        }
        return nil
    }

    

    public static func getUserId() -> Int {
        return getLoginUserData()?.userid ?? 0
    }
    
    public static func getRefreshToken() -> String {
        return getLoginUserData()?.Refresh_token ?? ""
    }
    
    public static func getRegisterOtpVerified() -> Bool {
        return getLoginUserData()?.is_registration_otp_verified ?? true
    }
    
    public static func getIsManager() -> Bool {
        return getLoginUserData()?.IsManager ?? false
    }
    
    public static func getIsToggleOn() -> Bool {
        return getCustomerDetailData()?.is_favorite_toggle_on ?? false
    }
    
    public static func get_is_guest() -> Bool {
        return getCustomerDetailData()?.is_guest ?? false
    }
    
    public static func getotp() -> Int {
        return getLoginUserData()?.otp ?? 0
    }
    
    public static func getmobile() -> String {
        return getLoginUserData()?.mobile ?? ""
    }
    
    public static func getFirstName() -> String {
        return getLoginUserData()?.Name ?? ""
    }
    
    public static func getLastName() -> String {
        return getLoginUserData()?.lastName ?? ""
    }


    public static func getLanguageId() -> Int {
        return getLoginUserData()?.langId ?? 0
    }
    
    public static func getOfficeLocation() -> String {
        return getLoginUserData()?.officeLocation ?? ""
    }


//    public static func getNewAccessToken() -> String {
//        return getLoginUserData()?.newAccessToen ?? ""
//    }


//    public static func getProviderId() -> Int? {
//        return getLoginUserData()?.providerId
//    }

    public static func getUserName() -> String {
        return getLoginUserData()?.userName ?? ""
    }

//    public static func getFirstName() -> String {
//        return getUserDetails()?.name?.firstname ?? (getLoginResponse()?.firstName ?? "")
//    }
//
//    public static func getLastName() -> String {
//        return getUserDetails()?.name?.lastname ?? (getLoginResponse()?.lastName ?? "")
//    }

    public static func getEmail() -> String {
        return getLoginUserData()?.email ?? ""
    }



    public static func getLoginUserData() -> User? {
        return UserDefaultUtils.getObject(forKey: .userData)
//        _ = UserDefaultUtils.getObject(forKey: .loginResponse)
//        let user =  Mappable(UserDefaultUtils.getObject(forKey: .loginResponse))
//        if let loginResponse = UserDefaultUtils.getObject(forKey: .loginResponse) {
//            return loginResponse
//        }
//        return nil
    }

    public static func setLoginUserData(userData: User) {
//        if let oldLoginResponse = getLoginResponse() {
//            loginResponse.localId = oldLoginResponse.localId
//        }
//        AnalyticsUtil.setUserIdForCrashlytics(userId: loginResponse.id ?? "id missing")
        UserDefaultUtils.setObject(userData, key: .userData)
    }
    
    
    
    public static func getCustomerDetailData() -> CustomerDetailUser? {
        return UserDefaultUtils.customerDetailsGetObject(forKey: .userDetails)
//        _ = UserDefaultUtils.getObject(forKey: .loginResponse)
//        let user =  Mappable(UserDefaultUtils.getObject(forKey: .loginResponse))
//        if let loginResponse = UserDefaultUtils.getObject(forKey: .loginResponse) {
//            return loginResponse
//        }
//        return nil
    }
    
    public static func setCustomerData(userData: CustomerDetailUser) {
//        if let oldLoginResponse = getLoginResponse() {
//            loginResponse.localId = oldLoginResponse.localId
//        }
//        AnalyticsUtil.setUserIdForCrashlytics(userId: loginResponse.id ?? "id missing")
        UserDefaultUtils.customerDetailsSetObject(userData, key: .userDetails)
    }


//    public static func setLanguagesStringsData(userData: LanguageAllTexts) {
//
//        UserDefaultUtils.setObject(userData, key: .languageData)
//    }
//
//
//    public static func getLanguagesStringsData() -> LanguageAllTexts? {
//        return UserDefaultUtils.getObject(forKey: .languageData)
//
//    }

//    public static func setUserDetails(userDetails: PersonDetailsModel) {
//        UserDefaultUtils.setObject(userDetails, key: .userDetails)
//    }
//
//    public static func getUserDetails() -> PersonDetailsModel? {
//        if let userDetails = UserDefaultUtils.getObject(forKey: .userDetails) as? PersonDetailsModel {
//            return userDetails
//        }
//        return nil
//    }
    
    
    
    public static func getCustomermobile() -> String {
        return getCustomerDetailData()?.mobile ?? ""
    }
    
    
    
    public static func getCustomerLastSearchedText() -> String {
        return getCustomerDetailData()?.last_searched_text ?? ""
    }
    
    public static func getCustomerAddressType() -> String {
        return getCustomerDetailData()?.address_type ?? "Other"
    }
    
    public static func getCustomerFirstName() -> String {
        return getCustomerDetailData()?.firstName ?? ""
    }
    
    public static func getCustomerLastName() -> String {
        return getCustomerDetailData()?.lastName ?? ""
    }


    public static func getCustomerLanguageId() -> Int {
        return getCustomerDetailData()?.langId ?? 0
    }


    public static func getCustomerUserName() -> String {
        return getCustomerDetailData()?.userName ?? ""
    }

    public static func getCustomerEmail() -> String {
        return getCustomerDetailData()?.email ?? ""
    }
    
    
    

    public static func setFbSignIn() {
        UserDefaultUtils.setBool(true, key: .fbSignIn)
    }

    public static func setGoogleSignIn() {
        UserDefaultUtils.setBool(true, key: .googleSignIn)
    }

    public static func setAppleSignIn() {
        UserDefaultUtils.setBool(true, key: .appleSignIn)
    }

    public static func getFbSignIn() -> Bool {
        return UserDefaultUtils.getBool(forKey: .fbSignIn)
    }

    public static func getGoogleSignIn() -> Bool {
        return UserDefaultUtils.getBool(forKey: .googleSignIn)
    }

    public static func getAppleSignIn() -> Bool {
        return UserDefaultUtils.getBool(forKey: .appleSignIn)
    }

    public static func setUserLoginRememberMe(rememberMe:Bool){
        UserDefaultUtils.setBool(rememberMe, key: .rememberMe)
    }

    public static func getUserLoginRememberMe() -> Bool {
        return UserDefaultUtils.getBool(forKey: .rememberMe)
    }


}
