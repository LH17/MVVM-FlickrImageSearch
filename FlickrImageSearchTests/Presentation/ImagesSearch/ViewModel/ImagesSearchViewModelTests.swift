//
//  ImagesSearchViewModelTests.swift
//  FlickrImageSearchTests
//
//  Created by lubaba on 3/13/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import XCTest

class ImagesSearchViewModelTests: XCTestCase {
    
    static var photos = [Photo(title: "Rainy Days and Mondays",
                               id: "49650749287",
                               owner: "137666838@N07",
                               url: "http://farm66.static.flickr.com/65535/49648371881_2e3d4c17f9.jpg", secret: "74a9c3ddb1",
                               server: "65535", farm: 66, ispublic: 1, isfriend: 0, isfamily: 0),
                         Photo(title: "Kite Flying",
                               id: nil,
                               owner: "23423571@N07",
                               url: "http://farm66.static.flickr.com/65535/49647651128_aeeb87822e.jpg", secret: nil,
                               server: nil, farm: nil, ispublic: 1, isfriend: 0, isfamily: 0)]
    
    class ImagesSearchUseCaseMock: ImagesSearchUseCase {
        var expectation: XCTestExpectation?
        
        func searchImages(with query: Image, page: Int, completion: @escaping (Result<[Photo], String?>) -> Void) {
            if query.name!.isEmpty {
                completion(Result.failure("Error Occured"))
            } else {
                completion(Result.success(ImagesSearchViewModelTests.photos))
            }
            expectation?.fulfill()
        }
    }
    
    func test_whenUseCaseReturnsPhotosList() {
        // given
        let useCase = ImagesSearchUseCaseMock()
        useCase.expectation = self.expectation(description: "Recent query fetched")
        let viewModel = DefaultImagesSearchViewModel(imagesSearchUseCase: useCase)
        // when
        viewModel.didSearch(query: "kite")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.viewModelCellArray.value.count, ImagesSearchViewModelTests.photos.count)
    }
    
    func test_whenUseCaseReturnsError() {
        // given
        let useCase = ImagesSearchUseCaseMock()
        useCase.expectation = self.expectation(description: "error")
        let viewModel = DefaultImagesSearchViewModel(imagesSearchUseCase: useCase)
        // when
        viewModel.didSearch(query: "")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.viewModelCellArray.value.count, 0)
        
    }
    
    func test_whendidLoadNextPageCalled() {
        // given
        let useCase = ImagesSearchUseCaseMock()
        useCase.expectation = self.expectation(description: "error")
        let viewModel = DefaultImagesSearchViewModel(imagesSearchUseCase: useCase)
        // when
        viewModel.didLoadNextPage()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.viewModelCellArray.value.count, 0)
        
    }
    
    func test_whenTimerCalled() {
        // given
        let useCase = ImagesSearchUseCaseMock()
        useCase.expectation = self.expectation(description: "error")
        let viewModel = DefaultImagesSearchViewModel(imagesSearchUseCase: useCase)
        // when
        viewModel.callTimer(with: "kite")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.viewModelCellArray.value.count, ImagesSearchViewModelTests.photos.count)
        
    }
    
    func test_getCellViewModel() {
        // given
        let useCase = ImagesSearchUseCaseMock()
        let viewModel = DefaultImagesSearchViewModel(imagesSearchUseCase: useCase)
        viewModel.viewModelCellArray.value = [PhotoListViewModelCell(imageUrl: "", descText: "kitten")]
        // when
        let viewModelCell = viewModel.getCellVM(at: IndexPath(row: 0, section: 0))
        
        // then
        XCTAssertEqual(viewModelCell.descText, "kitten")
        
    }
    
    func test_getNumberOfRows() {
        // given
        let useCase = ImagesSearchUseCaseMock()
        let viewModel = DefaultImagesSearchViewModel(imagesSearchUseCase: useCase)
        viewModel.viewModelCellArray.value = [PhotoListViewModelCell(imageUrl: "", descText: "kitten")]
        // when
        let rows = viewModel.getNumberOfRows()
        
        // then
        XCTAssertEqual(rows, 1)
        
    }

    func test_viewDidLoad() {
        // given
        let useCase = ImagesSearchUseCaseMock()
        let viewModel = DefaultImagesSearchViewModel(imagesSearchUseCase: useCase)
        // when
       viewModel.viewDidLoad()
        
        // then
        XCTAssertEqual(viewModel.error.value, "No Images Found")
        
    }
}
