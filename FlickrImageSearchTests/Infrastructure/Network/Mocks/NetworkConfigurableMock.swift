//
//  NetworkConfigurableMock.swift
//  FlickrImageSearchTests
//
//  Created by lubaba on 3/13/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL
    init(url: URL) {
        self.baseURL = url
    }
}
