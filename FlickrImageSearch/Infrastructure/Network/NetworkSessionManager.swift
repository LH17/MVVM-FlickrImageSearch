//
//  NetwrokSessionManager.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

public protocol NetworkSessionManager {
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest, completion: @escaping Completion)
}

public class DefaultNetworkSessionManager: NetworkSessionManager {
    public init() {}
    
    public func request(_ request: URLRequest, completion: @escaping Completion) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}
