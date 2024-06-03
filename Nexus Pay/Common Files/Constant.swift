//
//  Constant.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Foundation
import UIKit

//MARK:- messages
struct AppMessages {
    static let noInternetConnection = "No internet connection. Please try again."
    
    static let profileUpdated = "Profile updated successfully."
    static let enableLocation = "We don't have access to location services on your device. Please go to settings and enable services to use this feature."
    static let foundSnag = "Something went wrong. Please try again."
    static let overlayError = "Error occured. Please try again later."
    
    static var uploadInProgress = "Uploading is in progress..."
    static var videoSegmentsAndOverlayMerge = "Video segments and overlay merging is in progress..."
    static var overlayMerge = "Overlay merging is in progress..."
    static var wait = "Please wait..."
    static var addingIntroToVideo = "Adding intro to video..."
    static var addingOutroToVideo = "Adding outro to video..."
    static var addingMusicToVideo =  "Adding music to video..."
    static var segmentsMerging = "Segments merging is in progress. Please be patient as this may take a few minutes."
    static var videoCropping = "Video cropping as per our resolution is in progress..."
    static var videoMerging = "Video merging is in progress..."
    static var addingBackgroundMusic = "Adding background music to video..."
    
    static var blueToothRequired = "Please connect Bluetooth audio source."
    static var blueToothPopUp = "Please disconnect your Bluetooth mic so you can listen to the audio on this video preview"
}



//MARK:- alert messages
struct ValidationMessage{
    static let yourName = "Please enter your name."
    static let firstName = "Please enter customer's first name."
    static let emptyEmail = "Please enter email address."
    static let invalidEmail = "Please enter valid email address."
    static let emptyUserName = "Please enter username."
    static let emptyCode = "Please enter unlock code."
    static let emptyPwd = "Please enter password."
    static let emptyCurrentPwd = "Please enter old password."
    static let emptyNewPwd = "Please enter new password."
    static let emptyConfirmPwd = "Please retype new password."
    static let confirmPwdAlertMsg = "Password and confirm password does not match."
    static let incorrectPwdLength = "Please enter min. 6 characters long password."
    static let invalidPin = "Please enter 5 digit OTP to continue."
    static let emptyPhone = "Please enter phone number."
    static let validPhone = "Please enter 10 digits mobile number."
    static let countryCode = "Please enter country code"
    static let yourGender = "Please enter your Gender."
    static let emptyBio = "Please enter bio."
    static let emptyAge = "Please enter age."
    static let emptyExperience = "Please enter experience."
    static let emptySocialUrl = "Please enter any Social URl."
    static let acceptDeclaration = "Please read and accept declaration."
}

//alert popup messages
struct AlertMessages {
    //alert popup
    static let okStr = "OK"
    static let cancelStr = "Cancel"
    
    static let cancelRequestTitleStr = "Cancel Request"
    
    //logout confirmation alert title
    static let logoutTitleStr = "Logout User"
    static let logoutMsgStr = "Are you sure you want to logout?"
    static let errorOccured = "Error Occured!"
    static let networkError = "No internet connection. Please try again."
    
    
}

//MARK:- UserDefaults keys
struct UserDefault {
    static let user = "user"
    static let userType = "userType"
    static let secondaryUser = "secondaryUser"
    static let isLoggedIn = "isLoggedIn"
    static let deviceToken = "deviceToken"
    static let deviceId = "deviceId"
    static let selectedLanguage = "selectedLanguage"
    static let appleLanguagesKey = "AppleLanguages"
    static let profileImg = "profileImage"
    static let loginWithFb  = "loggedInWithFB"
    static let isShowCheck1 = "isShowCheck1"
    static let isShowCheck2 = "isShowCheck2"
}


//MARK:- Placeholders
struct Placeholders {
    static let pullToRefresh = "Pull To Refresh"
    static let updating = "Updating..."
}
