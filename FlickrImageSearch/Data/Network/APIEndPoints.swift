//
//  APIEndPoints.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

struct APIEndpoints {
    
    static func images(query: String, page: Int) -> EndPoint {
        
        return EndPoint(path: "services/rest/",
                        queryParameters: ["method": "flickr.photos.search",
                                          "api_key": "3e7cc266ae2b0e0d78e279ce8e361736",
                                          "format": "json",
                                          "nojsoncallback": 1,
                                          "safe_search": 1,
                                          "page": page,
                                          "per_page":15,
                                          "text": query])
    }
}

