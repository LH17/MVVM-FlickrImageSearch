//
//  NetworkSessionManagerMock.swift
//  FlickrImageSearchTests
//
//  Created by lubaba on 3/13/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest, completion: @escaping Completion) {
        completion(data, response, error)
    }
}
