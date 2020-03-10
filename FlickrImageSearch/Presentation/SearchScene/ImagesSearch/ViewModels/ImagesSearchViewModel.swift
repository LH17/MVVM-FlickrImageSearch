//
//  ImagesSearchViewModel.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

protocol ImagesSearchViewModel {
    
}

final class DefaultImagesSearchViewModel: ImagesSearchViewModel {
    private let imagesSearchUseCase: ImagesSearchUseCase
    
    /// Initialser
    /// - Parameter imagesSearchUseCase: ImagesSearchUseCase instance
    init(imagesSearchUseCase: ImagesSearchUseCase) {
       self.imagesSearchUseCase = imagesSearchUseCase
    }
}
