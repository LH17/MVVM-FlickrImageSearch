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
}

public struct ApiDataNetworkConfig: NetworkConfigurable {
    public let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

public final class DefaultNetworkService {
    public let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    
    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager()) {
        self.config = config
        self.sessionManager = sessionManager
    }
}

extension DefaultNetworkService: NetworkService {

    public func request(endpoint: EndPoint, completion: @escaping CompletionHandler) {
        
        do {
            let request = try endpoint.urlRequest(with: config)
            sessionManager.request(request) { data, response, requestError in
                
                if let _ = requestError {
                    var error: NetworkError?
                    if let response = response as? HTTPURLResponse {
                        error = .error(statusCode: response.statusCode, data: data)
                    }
                    if let err = error {
                        completion(.failure(err))
                    }
                    
                } else {
                    completion(.success(data))
                }
            }
        } catch {
            print(error)
        }
    }
}
