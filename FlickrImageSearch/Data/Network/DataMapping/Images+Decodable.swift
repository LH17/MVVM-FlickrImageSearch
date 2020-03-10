//
//  Images+Decodable.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

extension Image: Decodable {
    private enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.photos = try container.decode([Photo].self, forKey: .photos)
    }
}

extension Photo: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case secret
        case server
        case owner
        case farm
        case ispublic
        case isfriend
        case isfamily
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.secret = try container.decode(String.self, forKey: .secret)
        self.server = try container.decode(String.self, forKey: .server)
        self.farm = try container.decode(Int.self, forKey: .farm)
        self.ispublic = try container.decode(Int.self, forKey: .ispublic)
        self.isfriend = try container.decode(Int.self, forKey: .isfriend)
        self.isfamily = try container.decode(Int.self, forKey: .isfamily)
    }
}
