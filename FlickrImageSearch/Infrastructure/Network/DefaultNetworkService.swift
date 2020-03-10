//
//  AppDelegate.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import UIKit

public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

public struct ApiDataNetworkConfig: NetworkConfigurable {
    public let baseURL: URL
    public let headers: [String: String]
    public let queryParameters: [String: String]
    
    public init(baseURL: URL,
                headers: [String: String] = [:],
                queryParameters: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}

public final class DefaultNetworkService {
    public let config: NetworkConfigurable
    
    public init(config: NetworkConfigurable) {
        self.config = config
    }
}

extension DefaultNetworkService: NetworkService {
    public func get(url: String, parameters: [String : Any]?, headers: [String : String]?, encodingType: EncodingType, completion: @escaping CompletionClosure) {
        completion(Result.success([:]))
    }
}
