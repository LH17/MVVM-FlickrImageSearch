//
//  AppDelegate.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

/// Enum to manage the success and failure cases during network integration
/// - success: success case (200 - 300 status code)
/// - failure: failure case (encountered when thr request cannot be sent to the server e.g. internet connection error)
/// - error: error case (400-500 status code)
public enum Result<U, T> {
    case success(U)
    case failure(T)
}

/// Enum to manage error encountered during network integration
///
/// - error: error case with the message in the arguments
public enum ServerError: Error {
    case error(String?)
}

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
}

public typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void

/// Enum used to define how a set of parameters are applied to a `URLRequest`.
///
/// - url: Uses `JSONSerialization` which is set as the body of the request
/// - json: Creates a url-encoded query string to be applied to the body of the URL request
public enum EncodingType {
    case url
    case json
}

/// Protocol implemented by the NetworkManager class to include methods with POST, DELETE, PUT PATCH, GET requests
public protocol NetworkService {
    var config: NetworkConfigurable { get }
    func request(endpoint: Requestable, completion: @escaping CompletionHandler)
}
