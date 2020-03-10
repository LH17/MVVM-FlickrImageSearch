//
//  ImagesSearchUseCase.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//


protocol ImagesSearchUseCase {
     func searchImages(with query: Image, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
}

final class DefaultImagesSearchUseCase: ImagesSearchUseCase {
    
    private let imagesSearchRepository: ImagesSearchRepository
    
    init(imagesSearchRepository: ImagesSearchRepository) {
        self.imagesSearchRepository = imagesSearchRepository
    }
    
    func searchImages(with query: Image, page: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        imagesSearchRepository.searchImages(with: query, page: page) { result in
            switch result {
            case .success(let imageObject):
                completion(Result.success(imageObject.photos ?? []))
            default: break
            }
        }
    }
}
