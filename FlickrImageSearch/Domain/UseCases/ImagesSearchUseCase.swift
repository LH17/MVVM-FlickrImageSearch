//
//  ImagesSearchUseCase.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//


protocol ImagesSearchUseCase {
    
}

final class DefaultImagesSearchUseCase: ImagesSearchUseCase {
    private let imagesSearchRepository: ImagesSearchRepository
    
    init(imagesSearchRepository: ImagesSearchRepository) {
        self.imagesSearchRepository = imagesSearchRepository
    }
}
