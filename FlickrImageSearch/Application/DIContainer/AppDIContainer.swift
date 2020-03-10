//
//  AppDelegate.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfigurations = AppConfigurations()
    
    // MARK: - Network
    lazy var apiDataTransferService: NetworkService = {
        
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.imagesBaseURL)!)

        let apiDataNetwork = DefaultNetworkService(config: config)
        return apiDataNetwork
    }()

    
    // DIContainers of scenes
    func imagesSceneDIContainer() -> ImagesSceneDIContainer {
        let dependencies = ImagesSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return ImagesSceneDIContainer(dependencies: dependencies)
    }
}
