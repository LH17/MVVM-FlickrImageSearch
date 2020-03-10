//
//  ImagesSearchRepository.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

protocol ImagesSearchRepository {
     func searchImages(with query: Image, page: Int, completion: @escaping (Result<Image, String?>) -> Void)
}
