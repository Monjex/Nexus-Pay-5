//
//  BaseRouterProtocol.swift
//  Nexus Pay
//
//  Created by Tushar Fialok on 19/01/23.
//

import Foundation
import Alamofire

public typealias RequestHeaders = [String: String]
public typealias RequestBody = [String: Any]
public typealias RequestBodyAll = [String]
public typealias FilesMultipart = [[String: Any]]
public typealias QueryParams = [String: Any]
public typealias PathParams = [String: Any]
public typealias ResponseObject = [String: Any]
public typealias ResponseArray = [[String: Any]]
public typealias JSON = [String: Any]

protocol BaseRouterProtocol {

    var path: String { get }

    var method: Alamofire.HTTPMethod { get }

    var parameters: Alamofire.Parameters? { get }

    var body: AnyObject? { get }

    var headers: [String: String]? { get }
}
