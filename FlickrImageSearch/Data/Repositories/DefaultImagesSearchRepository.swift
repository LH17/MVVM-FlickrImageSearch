//
//  ImagesSearchRepository.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

final class DefaultImagesSearchRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultImagesSearchRepository: ImagesSearchRepository {
    func searchImages(with query: Image, page: Int, completion: @escaping (Result<Image, String?>) -> Void) {
        let endPoint = APIEndpoints.images(query: query.name ?? "", page: page)
        networkService.request(endpoint: endPoint) { result in
            switch result{
            case .success(let data):
                do {
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let photos = json?["photos"] as? [String: Any] {
                            let photosData = try JSONSerialization.data(withJSONObject: photos, options: [])
                            let imageObject: Image = try JSONDecoder().decode(Image.self, from: photosData)
                            completion(Result.success(imageObject))
                        }
                    } else {
                        completion(Result.failure("Data is not correct"))
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                    completion(Result.failure(error.localizedDescription))
                }
           default: break
            }
        }
    }
}
