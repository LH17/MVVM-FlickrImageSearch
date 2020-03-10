//
//  ImagesSearchViewModel.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

enum ImagesListViewModelLoading {
    case none
    case fullScreen
    case nextPage
}

protocol ImagesListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    var page: Int { get set }
}

protocol ImagesListViewModelOutput {
    var loadingType: Observable<ImagesListViewModelLoading> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get set }
}

protocol ImagesSearchViewModel: ImagesListViewModelOutput & ImagesListViewModelInput {}

final class DefaultImagesSearchViewModel: ImagesSearchViewModel {
    private let imagesSearchUseCase: ImagesSearchUseCase

    let loadingType: Observable<ImagesListViewModelLoading> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let screenTitle = NSLocalizedString("Images", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    var searchBarPlaceholder = NSLocalizedString("Search Images", comment: "")
    var page: Int = 1
    
    /// Initialser
    /// - Parameter imagesSearchUseCase: ImagesSearchUseCase instance
    init(imagesSearchUseCase: ImagesSearchUseCase) {
       self.imagesSearchUseCase = imagesSearchUseCase
    }
}

extension DefaultImagesSearchViewModel {
    func viewDidLoad() {
       
    }
    
    func didLoadNextPage() {
        
    }
    
    func didSearch(query: String) {
        page += 1
        imagesSearchUseCase.searchImages(with: Image(name: query), page: page) { result in
            
        }
    }
    
    func didCancelSearch() {
        
    }

    func showQueriesSuggestions() {
        
    }
    
    func closeQueriesSuggestions() {
        
    }
}
