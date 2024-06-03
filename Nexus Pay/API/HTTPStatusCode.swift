//
//  HTTPStatusCode.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Foundation

@objc public enum HTTPStatusCode: Int {

    /// OK: 200
    ///
    @objc(HTTPStatusCodeOK)
    case ok = 200

    /// Created: 201
    ///
    case created = 201
    /// Accepted: 202
    ///
    case accepted = 202

    /// No Content: 204
    ///
    case noContent = 204

    // Bad Request: 400
    ///
    case badRequest = 400
    /// Unauthorized: 401
    ///
    case unauthorized = 401
    /// Forbidden: 403
    ///
    case forbidden = 403
    /// Request Timeout: 408
    case requestTimeout = 408
    /// Unprocessable Entity: 422
    case unprocessableEntity = 422

    /// Internal Server Error: 500
    case internalServerError = 500
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended = 510
    case networkAuthenticationRequired

}
