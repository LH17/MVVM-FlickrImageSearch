//
//  ImagesSceneDIContainer.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

final class ImagesSceneDIContainer {

    struct Dependencies {
        let apiDataTransferService: NetworkService
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases
    func makeImagesSearchUseCase() -> ImagesSearchUseCase {
        return DefaultImagesSearchUseCase(imagesSearchRepository: makeImagesSearchRepository())
    }

    func makeImagesSearchRepository() -> ImagesSearchRepository {
        return DefaultImagesSearchRepository(networkService: dependencies.apiDataTransferService)
    }

    func makeImagesSearchViewModel() -> ImagesSearchViewModel {
        return DefaultImagesSearchViewModel(imagesSearchUseCase: makeImagesSearchUseCase())
    }

    func makeImagesSearchViewController() -> ImagesSearchViewController {
        return ImagesSearchViewController.create(with: makeImagesSearchViewModel())
    }
}
