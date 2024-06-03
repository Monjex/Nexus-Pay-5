//
//  UserDefaultsUtils.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 12/06/23.
//

import Foundation
import ObjectMapper

class UserDefaultUtils {
    public enum ReservedKey: String {
        case userData
        case loginResponse
        case googleSignIn
        case appleSignIn
        case fbSignIn
        case reminderTime
        case reminder
        case firstOpen
        case secondOpen
        case subscription
        case moodTrackerOffering
        case lastCountOfSocialFeed
        case userAccessRole
        case userDetails
        case questionaireId
        case questionaireEnabled
        case goals
        case emailOptin
        case rememberMe
        case languageData
        case deviceFcmToken
        case officeLocation
    }
    
    public static func setObject<T>(_ value: T, key: ReservedKey) where T: Codable {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(value) {
                let userDefaults = UserDefaults.standard
                userDefaults.set(encoded, forKey: key.rawValue)
                userDefaults.synchronize()
            }else{
                print("Object not saved")
            }
    }
    
    
    
    public enum CustomerDetailsReservedKey: String {
        case customerDetailUserData
        case loginResponse
        case googleSignIn
        case appleSignIn
        case fbSignIn
        case reminderTime
        case reminder
        case firstOpen
        case secondOpen
        case subscription
        case moodTrackerOffering
        case lastCountOfSocialFeed
        case userAccessRole
        case userDetails
        case questionaireId
        case questionaireEnabled
        case goals
        case emailOptin
        case rememberMe
        case languageData
        case deviceFcmToken
    }
    
    public static func customerDetailsSetObject<T>(_ value: T, key: CustomerDetailsReservedKey) where T: Codable {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(value) {
                let userDefaults = UserDefaults.standard
                userDefaults.set(encoded, forKey: key.rawValue)
                userDefaults.synchronize()
            }else{
                print("Object not saved")
            }
    }
    

    
//    public static func setObject(_ value: Any, key: ReservedKey) {
////        let encoded = NSKeyedArchiver.archivedData(withRootObject: value)
//        do{
//        let userDefaults = UserDefaults.standard
//
//        let encoded = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
//        userDefaults.set(encoded, forKey: key.rawValue)
//        userDefaults.synchronize()
//        }catch {
//            print("not saved \(error)")
//        }
//    }

//    public static func getObject<T>(forKey key: ReservedKey,_ type:T.Type) -> T? where T : Mappable {
//        let userDefaults = UserDefaults.standard
//
//
//        let text = userDefaults.string(forKey: key.rawValue)
//                if(text == nil || text?.count == 0){
//                    return nil
//                }else{
//                    return Mapper<T>().map(JSONString: text!)
//                }
//
//
////        if let encoded = userDefaults.object(forKey: key.rawValue) as? Data {
////            return NSKeyedUnarchiver.unarchiveObject(with: encoded) as AnyObject
////        }
//
//        return nil
//    }
    
    public static func getObject<T>(forKey key: ReservedKey) -> T? where T: Codable{
        //do {
            let userDefaults = UserDefaults.standard

            if let encoded = userDefaults.object(forKey: key.rawValue) as? Data {
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(T.self, from: encoded) {
                    return result
                }else{
                    print("Error in decoding")
                }
            }else{
                print("Error in gettingdata from userdefaults")
            }
//        }catch {
//            print("Unable to get Object from UserDefauts(\(error)")
//        }

        return nil
    }
    
    
    public static func customerDetailsGetObject<T>(forKey key: CustomerDetailsReservedKey) -> T? where T: Codable{
        //do {
            let userDefaults = UserDefaults.standard

            if let encoded = userDefaults.object(forKey: key.rawValue) as? Data {
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(T.self, from: encoded) {
                    return result
                }else{
                    print("Error in decoding")
                }
            }else{
                print("Error in gettingdata from userdefaults")
            }
//        }catch {
//            print("Unable to get Object from UserDefauts(\(error)")
//        }

        return nil
    }
    
//    public static func getObject(forKey key: ReservedKey) -> AnyObject? {
//
//        do {
//        let userDefaults = UserDefaults.standard
//
//        if let encoded = userDefaults.object(forKey: key.rawValue) as? Data {
//            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encoded) as AnyObject
//        }
//        }catch {
//            print("Error \(error)")
//        }
//        return nil
//    }
    
    
//    public static func getObject(forKey key: ReservedKey) -> AnyObject?{
//        //do {
//            let userDefaults = UserDefaults.standard
//
//            if let encoded = userDefaults.object(forKey: key.rawValue) as? Data {
//                let decoder = JSONDecoder()
//                let obj : AnyObject
//                if let result = try? decoder.decode(AnyObject, from: encoded) {
//                    return result
//                }else{
//                    print("Error in decoding")
//                }
//            }else{
//                print("Error in gettingdata from userdefaults")
//            }
////        }catch {
////            print("Unable to get Object from UserDefauts(\(error)")
////        }
//
//        return nil
//    }
    
    
    public static func setJsonValue(_ value:Any, key: ReservedKey) {
       UserDefaultUtils.setValue(value, forKey: key.rawValue)
    }
    
    public static func getJsonValue(forKey key:ReservedKey) -> Any? {
         return UserDefaultUtils.getValue(forKey: key.rawValue)
    }
    
    public static func setValue(_ value:Any, forKey:String) {
       let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: forKey)
    }
    
    public static func getValue(forKey:String) -> Any? {
         let userDefaults = UserDefaults.standard
         return userDefaults.value(forKey: forKey)
    }
    
    public static func removeValue(withKey:String) {
        UserDefaults.standard.removeObject(forKey: withKey)
    }
        
    public static func setBool(_ value: Bool, key: ReservedKey) {
        UserDefaultUtils.setValue(value, forKey: key.rawValue)
    }
    
    public static func getBool(forKey key: ReservedKey) -> Bool {
        return UserDefaultUtils.getValue(forKey: key.rawValue) as? Bool ?? false
    }
    
    public static func setDate(_ value: Date, key: ReservedKey) {
        UserDefaultUtils.setValue(value, forKey: key.rawValue)
    }
    
    public static func getDate(forKey key: ReservedKey) -> Date? {
        return UserDefaultUtils.getValue(forKey: key.rawValue) as? Date
    }
    
    public static func setSecondOpen() {
        UserDefaultUtils.setBool(true, key: .secondOpen)
    }
    
    public static func getSecondOpen() -> Bool {
        return UserDefaultUtils.getBool(forKey: .secondOpen)
    }
    
    public static func clearUserDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    
    public static func setDeviceToken(_ value: String, key: ReservedKey) {
        UserDefaultUtils.setValue(value, forKey: key.rawValue)
    }
    
    public static func getDeviceToken(forkey key: ReservedKey) -> String? {
        UserDefaultUtils.getValue(forKey: key.rawValue) as? String
    }
    
}
