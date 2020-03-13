//
//  EndPoint.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

enum URLError: Error {
    case components
}
public protocol Requestable {
    var path: String { get set }
    var queryParameters: [String: Any] { get set }
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest
}

public struct EndPoint: Requestable {
    public var path: String
    public var queryParameters: [String: Any]
    
    init(path: String, queryParameters: [String: Any]) {
        self.path = path
        self.queryParameters = queryParameters
    }
    
    public func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        return URLRequest(url: url)
    }
    
    private func url(with config: NetworkConfigurable) throws -> URL {

        let baseURL = config.baseURL.absoluteString
        let endpoint = baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw URLError.components }
        var urlQueryItems = [URLQueryItem]()
        
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw URLError.components }
        return url
    }
}
