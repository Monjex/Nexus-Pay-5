//
//  APIError.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Foundation

/// The key to use in an NSError userInfo dictionary to retrieve the HTTP status code
public let HTTPStatusCodeNSErrorUserInfoKey = "httpStatusCode"

/// NSError extension to standardise domain and httpStatusCode insertion/extraction
extension NSError {
    
    /// Convenience method to create an NSError with a code, and optionally a httpStatusCode.
    /// The domain will be set to the SDK's bundleIdentifier, and the httpStatusCode will be added as the userInfo.
    convenience init(code: Int, httpStatusCode: Int? = nil) {
        let domain = Bundle.main.bundleIdentifier!
        let userInfo: [String: Any]?
        
        if let httpStatusCode = httpStatusCode {
            userInfo = [HTTPStatusCodeNSErrorUserInfoKey: httpStatusCode]
        } else {
            userInfo = nil
        }
        
        self.init(domain: domain, code: code, userInfo: userInfo)
    }
    
    /// Retrieve the httpStatusCode from an NSError.
    /// Returns the code if it is in the userInfo in the style init(code:httpStatusCode:) added it, or nil if it is not.
    func httpStatusCode() -> Int? {
        if let userInfo = self.userInfo as? [String: Int] {
            return userInfo[HTTPStatusCodeNSErrorUserInfoKey]
        }
        
        return nil
    }
}

/// Enumeration to list the errors that can occur in any request.
public enum APIError: LocalizedError, CustomStringConvertible {
    case error(String)

    case requestCannotPrepareBody
    case requestNotSent(String)
    case requestError(Int, String)

    case operationConfigurationError(String)
    case operationInputParameterMissing(String)
    case operationNotSupported(String)
    
    /// Error to return if request time out/ not received response.
    case noResponseReceived

    /// Error to return if user is offline.
    case noInternetAvailable

    /// Error to return when parsing JSON fails.
    case parseError

    /// Error to return if user doesn't have access to a particular API.
    case accessDeniedError

    /// Error to return if the user is not authenticated.
    case unauthorized
    
    /// Error to return if the user's role does not grant them access to this method.
    case forbidden
    
    /// Error to return if an error occurs that we can not handle.
    case unhandledError
    
    case socialLoginFailure
    
    // MARK: - CustomStringConvertible
    public var description: String {
        switch self {
        case .error(let message):
            return message

        case .requestCannotPrepareBody:
            return "`RequestHandler` cannot prepare request body data.".localized
        case .requestNotSent(let reason):
            return "\(reason)"
        case .requestError(_, let message):
            return "\(message)"
        case .noResponseReceived:
            return "No response received.".localized
        case .operationConfigurationError(let message):
            return message
        case .operationInputParameterMissing(let name):
            return "\("Operation is missing input parameter.".localized): “\(name)”"
        case .operationNotSupported(let name):
            return "\("Operation is not supported.".localized): \(name)"
        case .noInternetAvailable:
            return "\("Sorry, no internet connectivity detected. \n Please reconnect and try again.".localized)"
        case .parseError:
            return "\("Error".localized) \("Failed to parse JSON.".localized)"
        case .accessDeniedError:
            return "\("Error".localized) \("access denied.".localized)"
        case .unauthorized:
            return "\("Error".localized) \("unauthorized.".localized)"
        case .forbidden:
            return "\("Error".localized) \("forbidden.".localized)"
        case .unhandledError:
            return "\("Error".localized)"
        case .socialLoginFailure:
            return "Sign up could not be completed. Please try again".localized
        }
    }
    
    public var errorDescription: String? {
        get {
            return self.description
        }
    }
}

extension Error {
    /**
     Converts any `Error` into `AppError`; returns self if the receiver is a AppError already.
     */
    public var asAppError: APIError {
        if let ferr = self as? APIError {
            return ferr
        }
        return APIError.error("\(localizedDescription)")
    }
}

extension String {
    /**
     Convenience getter using `NSLocalizedString()` with no comment.
     */
    public var localized: String {
        return NSLocalizedString(self, comment: "")
    }

}
