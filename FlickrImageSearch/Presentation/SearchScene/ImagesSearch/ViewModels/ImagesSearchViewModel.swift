//
//  ImagesSearchViewModel.swift
//  FlickrImageSearch
//
//  Created by lubaba on 3/10/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import Foundation

protocol ImagesListViewModelInput {
    var page: Int { get set }
    var query: String? { get set }
    var searchBarPlaceholder: String { get set }
    var errorTitle: String { get }
    var emptyDataTitle: String { get }
    
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func callTimer(with text: String)
}

protocol ImagesListViewModelOutput {
    var isLoading: Observable<Bool> { get set }
    var error: Observable<String?> { get set }
    var section: Int { get }
    var viewModelCellArray: Observable<[PhotoListViewModelCell]> { get set }
    var screenTitle: String { get }
    
    func getNumberOfRows() -> Int
    func getCellVM(at indexPath: IndexPath) -> PhotoListViewModelCell
}

protocol ImagesSearchViewModel: ImagesListViewModelOutput & ImagesListViewModelInput {}

final class DefaultImagesSearchViewModel: ImagesSearchViewModel {
    private let imagesSearchUseCase: ImagesSearchUseCase
    private var photos: [Photo] = [Photo]()
    private let debounceTimer = DebounceTimer(interval: 0.7)
    
    var isLoading: Observable<Bool> = Observable(false)
    var viewModelCellArray: Observable<[PhotoListViewModelCell]> = Observable([])
    let screenTitle = NSLocalizedString("Images", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    var section: Int = 1
    let errorTitle = NSLocalizedString("Error", comment: "")
    var searchBarPlaceholder = NSLocalizedString("Search Images", comment: "")
    var page: Int = 1
    var error: Observable<String?> = Observable<String?>("No Image Found")
    var query: String?
    
    /// Initialser
    /// - Parameter imagesSearchUseCase: ImagesSearchUseCase instance
    init(imagesSearchUseCase: ImagesSearchUseCase) {
        self.imagesSearchUseCase = imagesSearchUseCase
    }
}

extension DefaultImagesSearchViewModel {
    func getNumberOfRows() -> Int {
        return viewModelCellArray.value.count
    }
    
    func viewDidLoad() {
        error.value = "No Images Found"
    }
    
    func callTimer(with text: String) {
        debounceTimer.call()
        debounceTimer.callback = { [weak self] in
            self?.didSearch(query: text)
        }
    }
    
    func didLoadNextPage() {
        page += 1
        searchImages(query ?? "")
    }
    
    func didSearch(query: String) {
        self.query = query
        page = 1
        viewModelCellArray.value = []
        searchImages(query)
    }
    
    private func searchImages(_ query: String) {
        isLoading.value = true
        imagesSearchUseCase.searchImages(with: Image(name: query), page: page) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.createViewModelCell(photos)
                self?.isLoading.value = false
                self?.error.value = nil
            case .failure(let errorMessage):
                self?.error.value = errorMessage
                self?.viewModelCellArray.value = []
            default: break
            }
        }
    }
    
    private func createViewModelCell(_ photos: [Photo]) {
        var viewModelCells: [PhotoListViewModelCell] = []
        for photo in photos {
            viewModelCells.append(PhotoListViewModelCell(imageUrl: photo.url ?? "", descText: photo.title ?? ""))
        }
        viewModelCellArray.value += viewModelCells
    }
    
    func getCellVM(at indexPath: IndexPath) -> PhotoListViewModelCell {
        return (viewModelCellArray.value)[indexPath.row]
    }
}

struct PhotoListViewModelCell {
    let imageUrl: String
    let descText: String
}
