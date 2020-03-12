//
//  Image.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

struct Image {
    var name: String?
    var photos: [Photo]?
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String?, photos: [Photo]?) {
        self.name = name
        self.photos = photos
    }
}

struct Photo {
    var title: String?
    var id: String?
    var owner: String?
    var url: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
}
