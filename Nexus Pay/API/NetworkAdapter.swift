//
//  NetworkAdapter.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Alamofire
import Reachability

/*
 * Http Error Response Class to Handle all Http Specific Errors. Here this is inherited from NSError Class
 * and modified to suit our needs. It will take the statusCode, Server Error Code and Server Error
 * Description and will put it in code, domain and localizedDescription fields of NSError Class
 * accordingly.
 */


let networkAdapterErrorDomain = "com.esp.networkadaptor"

public class HttpResponseError: NSError {

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Custom Initializer.
    ///
    /// - Parameters:
    ///   - statusCode: Http Status Code.
    ///   - serverErrorCode: Error Code sent from the server in response body.
    ///   - serverErrorDescription: Error Description sent from the server in response body.
    public init(domain: String?, statusCode: Int, serverErrorDescription: String?) {
        super.init(domain: domain != nil ? domain! : "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: serverErrorDescription != nil ? serverErrorDescription!: ""])
    }
}

/// Network Adapter for routing all the Requests. It is a wrapper around Alamofire Request method to provide custom hooks for the requests and response.

public class NetworkAdapter {
    private static var reachability: Reachability { try! Reachability() }

    public class func request(_ urlRequest: URLRequestConvertible,
                              completionHandler: @escaping (Any) -> Void,
                              errorHandler: @escaping (NSError) -> Void,
                              networkErrorHandler: () -> Void) {
        //AnalyticsUtil.setCustomValueForCrashlytics(url: urlRequest.urlRequest?.url?.absoluteString ?? "", key: "last_api")
        if reachability.connection != .unavailable {
            AF.request(urlRequest).validate().responseJSON { (response) in
                if let value = response.value {
                    /*if let metrics = response.metrics,  let responseObj = response.response {
                        //Convert seconds from duration to milliseconds
                        let milliseconds = metrics.taskInterval.duration * 1000
                        if (NSNumber(value: milliseconds) > (FirebaseHelper.shared.remoteApiLoggingThreshold ?? 300)) {
                            let exceptionModelName = "api_success, \(responseObj.statusCode) - \(urlRequest.urlRequest?.url?.path ?? "")"
                            let reasonDict = ["curl": response.request?.cURL() ?? "",
                                              "response_time_ms": Int(milliseconds),
                                              "date_time":DateUtil.toDateTimeZoneString(fromDateWithZone: Date()) ?? "",
                                              "collective_user_id" : AuthUtils.getUserId() ?? "guest"] as [String : Any]
                            AnalyticsUtil.setExceptionModelForCrashlytics(name: exceptionModelName, reason: reasonDict.jsonStringRepresentation ?? "")
                        }
                    }*/
                    completionHandler(value)
                    
                    
//                    if let responseJSON = response.value as? JSON, let baseResponse = BaseResponse(JSON: responseJSON){
//                        if baseResponse.statusCode == HTTPStatusCode.unauthorized.rawValue{
//                            print(response.value)
//                            if let group = kAppDelegate.dispatch_GroupJNB{
//                                group.suspend()
//                            }
//                            SharedInstance.shared.hideLoader()
//                            kAppDelegate.setForLogout {
//
//                            }
//                        }else {
//                            completionHandler(value)
//                        }
//                    }else{
//                        errorHandler(self.handleErrorFor(response: response))
//                    }
                    
                    
                    
                }else {
                    /*if let metrics = response.metrics, let responseObj = response.response {
                        let exceptionModelName = "api_error, \(responseObj.statusCode) - \(urlRequest.urlRequest?.url?.path ?? "")"
                        let milliseconds = metrics.taskInterval.duration * 1000
                        let reasonDict = ["curl": response.request?.cURL() ?? "",
                                          "response": responseObj.description,
                                          "response_time_ms": Int(milliseconds),
                                          "date_time":DateUtil.toDateTimeZoneString(fromDateWithZone: Date()) ?? "",
                                          "collective_user_id" : AuthUtils.getUserId() ?? "guest"] as [String : Any]
                        AnalyticsUtil.setExceptionModelForCrashlytics(name: exceptionModelName, reason: reasonDict.jsonStringRepresentation ?? "")
                        let loggerDict = ["title": exceptionModelName, "reason": reasonDict] as [String : Any]
                        writeLogFileInDirectory(loggerDict.jsonStringRepresentation ?? "", "log.txt")
                    }*/
                    errorHandler(self.handleErrorFor(response: response))
                }
            }.cURLDescription { (curl) in
                print(curl)
            }.cacheResponse(using: CustomCacheResponseHandler.shared)

        } else {
            
            networkErrorHandler()
        }
    }
    
    public class func requestString(_ urlRequest: URLRequestConvertible,
                              completionHandler: @escaping (Any) -> Void,
                              errorHandler: @escaping (Error) -> Void,
                              networkErrorHandler: () -> Void) {
        //AnalyticsUtil.setCustomValueForCrashlytics(url: urlRequest.urlRequest?.url?.absoluteString ?? "", key: "last_api")
        if reachability.connection != .unavailable {
            AF.request(urlRequest).validate().responseString() { (response) in
                if let value = response.value {
                    completionHandler(value)
                }else {
                    errorHandler(APIError.error(String(data: response.data ?? Data(), encoding: .ascii) ?? "Not able to decode"))
                }
            }.cURLDescription { (curl) in
                print(curl)
            }.cacheResponse(using: CustomCacheResponseHandler.shared)

        } else {
            
            networkErrorHandler()
        }
    }
    
    
    public class func uploadDataWithRequestBody(dataFile: Data, isImage:Bool,fileName:String, body: [String: Any], withURL:String,
                                                successCallback: @escaping ((_ response: JSON?) -> Void),
                                                errorCallback: @escaping ((_ error: Error) -> Void),
                                                networkCallback: @escaping (() -> Void)) {
        //let urlString = "https://collective-qa.stage-roundglass.com/media/api/v2/media"
        let urlString = withURL
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "x-col-jwt" : ""
        ]
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in body {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                }
                
                var uploadingFileName = fileName.replacingOccurrences(of: " ", with: "_")
                uploadingFileName = uploadingFileName.replacingOccurrences(of: "-", with: "")
                if isImage {
                    multipartFormData.append(dataFile, withName: "media", fileName: uploadingFileName, mimeType: "icon/png")
                }else {
                    multipartFormData.append(dataFile, withName: "media", fileName: uploadingFileName, mimeType: "video/mp4")
                }

            },
            to: urlString,
            method: .post,
            headers: headers)
            .cURLDescription(calling: { (curl) in
            })
            .uploadProgress(queue: .main, closure: { progress in
            })
            .responseJSON { (response) in
                switch response.result {
                case .success(let json):
                    if let responseJSON = json as? JSON {
                        successCallback(responseJSON)
                    }
                break
                case .failure(let error):
                    errorCallback(error)
                break
                }
            }
    }
    
    public class func uploadRequest(files:FilesMultipart, body: RequestBody,_ urlRequest: URLRequestConvertible,completionHandler: @escaping (Any) -> Void,
                                    errorHandler: @escaping (NSError) -> Void,
                                    networkErrorHandler: () -> Void) {
        
        if reachability.connection != .unavailable {
        AF.upload(multipartFormData: {multipartFormData in
            
            for (key, value) in body {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            for file in files {
                
                //multipartFormData.append((file["data"] as? Data)!, withName: "AttachFiles")
                multipartFormData.append((file["data"] as? Data)!, withName: (file["name"] as? String)!, fileName: file["fileName"] as? String, mimeType: file["mimeType"] as? String)
                
            }
            
        }, with: urlRequest,usingThreshold: UInt64.init()).cURLDescription(calling: { (curl) in
            print(curl)
        })
        .uploadProgress(queue: .main, closure: { progress in
        })
        .responseJSON { (response) in
            if let value = response.value {
                completionHandler(value)
            }else {
                errorHandler(self.handleErrorFor(response: response))
            }
        }
        }else{
            networkErrorHandler()
        }
        
        /*
         
         AF.upload(
         multipartFormData: { multipartFormData in
         for (key, value) in body {
         if let temp = value as? String {
         multipartFormData.append(temp.data(using: .utf8)!, withName: key)
         }
         }
         
         var uploadingFileName = fileName.replacingOccurrences(of: " ", with: "_")
         uploadingFileName = uploadingFileName.replacingOccurrences(of: "-", with: "")
         if isImage {
         multipartFormData.append(dataFile, withName: "media", fileName: uploadingFileName, mimeType: "icon/png")
         }else {
         multipartFormData.append(dataFile, withName: "media", fileName: uploadingFileName, mimeType: "video/mp4")
         }
         
         },
         to: urlString,
         method: .post,
         headers: headers)
         .cURLDescription(calling: { (curl) in
         })
         .uploadProgress(queue: .main, closure: { progress in
         })
         .responseJSON { (response) in
         switch response.result {
         case .success(let json):
         if let responseJSON = json as? JSON {
         successCallback(responseJSON)
         }
         break
         case .failure(let error):
         errorCallback(error)
         break
         }
         }
         */
    }
    
    
    /// Method to create and return HttpResponseError if error is encountered
    ///
    /// - Parameter response: Data Response received from the Server.
    /// - Returns: HttpResponseError Object.
    private class func handleErrorFor<Success>(response: AFDataResponse<Success>) -> HttpResponseError {
//        if response.error?.responseCode == 401 && AuthUtils.getUserId() != nil {
//            logout(deleteData: false)
//        }
        var responseDictionary = [String: Any]()
        if let data = response.data {
            do {
                if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    responseDictionary = responseDict
                }
            } catch {
                print(error)
            }
        }
        if let errorDictionary = responseDictionary["error"] as? [String: Any] {
            return HttpResponseError(domain: networkAdapterErrorDomain, statusCode: response.response!.statusCode, serverErrorDescription: errorDictionary["description"] as? String)
        }
        if let message = responseDictionary["message"] as? String {
            return HttpResponseError(domain: networkAdapterErrorDomain, statusCode: response.response!.statusCode, serverErrorDescription: message)
        }
        if response.response != nil {
            return HttpResponseError(domain: networkAdapterErrorDomain, statusCode: response.response!.statusCode, serverErrorDescription: nil)
        } else {
            return HttpResponseError(domain: networkAdapterErrorDomain, statusCode: HTTPStatusCode.requestTimeout.rawValue, serverErrorDescription: nil)
        }
    }
}

class CustomCacheResponseHandler: CachedResponseHandler {
    private init () {}
    
    static var shared = CustomCacheResponseHandler()
    
    static var cache = URLCache(memoryCapacity: 1024*1024*1, diskCapacity: 1024*1024*200, diskPath: "myDataPath")
    
    func dataTask(_ task: URLSessionDataTask, willCacheResponse response: CachedURLResponse, completion: @escaping (CachedURLResponse?) -> Void) {
        if let request = task.originalRequest, request.method == .get {
            CustomCacheResponseHandler.cache.storeCachedResponse(response, for: request)
        }
        completion(response)
    }
    
    func getCachedResponse(_ urlRequest: URLRequestConvertible) -> Any? {
        if let request = urlRequest.urlRequest, let cachedResponse = CustomCacheResponseHandler.cache.cachedResponse(for: request), let responseObj = try? JSONSerialization.jsonObject(with: cachedResponse.data, options: []) {
            return responseObj
        }
        return nil
    }
    
    static func clearCache() {
        cache.removeAllCachedResponses()
    }
}
