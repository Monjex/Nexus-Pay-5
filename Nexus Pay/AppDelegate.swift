//
//  AppDelegate.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 17/01/23.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import Messages
import FirebaseMessaging
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Ebable Keyboard
        IQKeyboardManager.shared.enable = true
        
        setUpNotification(application: application)
        
//        DispatchQueue.global().async {
//                self.getCountryData()
//            }
//        
//        Thread.sleep(forTimeInterval: 10.0)
//        
        //GMSPlacesClient.provideAPIKey("API-KEY")
       // GMSServices.provideAPIKey("AIzaSyAsw7pC4oD_0JCcRWrle_vuKnxVpnq3wDk")
        
        
        return true
    }
    
    
    func setUpNotification(application: UIApplication) {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    // the FCM registration token.
       func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           print("APNs token retrieved: \(deviceToken)")
           let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    
         //   UserDefaultUtils.setDeviceToken(tokenString, key: .deviceFcmToken)
        
        
          UserDefaults.standard.setValue(tokenString, forKey: "device_token")
          // UserData.shared.device_token = tokenString
           print("this will return '32 bytes' in iOS 13+ rather than the token \(tokenString)")
           
           // With swizzling disabled you must set the APNs token here.
           Messaging.messaging().apnsToken = deviceToken
       }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func getCountryData() {
                
        // Show Loder
       // loader.addLoader(view: self.view)
        //self.showIndicator(withTitle: "Loading...")
        //self.showGif()
       // ActivityLoader.shared.showLoaderCentered()
        
        // Get AutorizationToken
       // let AutorizationToken = UserDefaults.standard.string(forKey: "UserAuthorisationToken") ?? ""
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(AuthUtils.getAuthToken() ?? "")"
        ]
        
        AF.request("\(APIConstants.Collective.authBaseURL)ApplyRequest/GetLeaveSummaryFilter", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    
                 //   print(response.value!)
                    let json = response.value as? [String: Any]
                    if json != nil{
                        let json : NSDictionary = response.value as? NSDictionary ?? [:]
                        print(json)
                        let status = json.value(forKey: "StatusCode") as? Int ?? 0
                        let message = json.value(forKey: "Message") as? String ?? ""
                        if status == 200 {

                            print(json)
                            
                            // Hide Loader
                           // self.loader.removeLoader(view: self.view)
                            //self.hideIndicator()
                            //self.hideGif()
                            //ActivityLoader.shared.hideLoader()
                            
                            let data = json.value(forKey: "Data") as? NSDictionary ?? [:]

                            //self.typeArr = data.value(forKeyPath: "LeaveList") as? NSArray ?? []
                            //self.statusArr = data.value(forKeyPath: "StatusList") as? NSArray ?? []
                            
                            //self.setIsMyRequests(isMyRequest: true, leaveType: self.type, leaveStatus: self.status, leaveFrom: self.fromdate)
                            
                        }
                        else if status == 401{
                            
                            //self.fromRefresh = "Filter"
                            
                            //self.refreshTokenCall(accesstoken: "Bearer \(AuthUtils.getAuthToken() ?? "")", refreshtoken: AuthUtils.getRefreshToken(), group: nil)
                        }
                        else{
                            // Hide Loader
                            //self.hideIndicator()
                            //self.hideGif()
                            //ActivityLoader.shared.hideLoader()
                          //  self.loader.removeLoader(view: self.view)
                            //self.showAlert(msg: message)
                        }
                    }
                    else {
                        // Hide Loader
                        //self.loader.removeLoader(view: self.view)
                        //self.hideIndicator()
                        //self.hideGif()
                        //ActivityLoader.shared.hideLoader()
            
                    }
                    
                }
            }


}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")

       // UserDefaults.standard.setValue(fcmToken, forKey: "fcm_token")
        
        UserDefaultUtils.setDeviceToken(fcmToken!, key: .deviceFcmToken)

       // let dataDict:[String: String] = ["token": fcmToken!]
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

      //  UserData.shared.fcm_token = fcmToken
       // let dataDict:[String: String] = ["token": fcmToken]
       // NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    @objc func checkNotificationContent(NotificationType: String,NotificationMsg: String,userInfo: NSDictionary) {
        
    }
}

