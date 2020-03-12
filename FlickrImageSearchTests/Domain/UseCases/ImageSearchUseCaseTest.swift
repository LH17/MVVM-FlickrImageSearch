//
//  ImageSearchUseCaseTest.swift
//  FlickrImageSearchTests
//
//  Created by lubaba on 3/12/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import XCTest

class ImageSearchUseCaseTest: XCTestCase {

    static var photos = [Photo(title: "Rainy Days and Mondays",
                        id: "49650749287",
                        owner: "137666838@N07",
                        url: "http://farm66.static.flickr.com/65535/49648371881_2e3d4c17f9.jpg", secret: "74a9c3ddb1",
                        server: "65535", farm: 66, ispublic: 1, isfriend: 0, isfamily: 0),
   Photo(title: nil,
    id: nil,
    owner: "23423571@N07",
    url: "http://farm66.static.flickr.com/65535/49647651128_aeeb87822e.jpg", secret: nil,
    server: nil, farm: nil, ispublic: 1, isfriend: 0, isfamily: 0)]

    static var imageObject = Image(name: "kittens", photos: photos)
    static var imageObjectEmpty = Image(name: "kittens", photos: nil)
    
    class ImageSearchRepoSuccessMock: ImagesSearchRepository {
        func searchImages(with query: Image, page: Int, completion: @escaping (Result<Image, String?>) -> Void) {
            completion(Result.success(query))
        }
    }
    
    class ImageSearchRepoFailureMock: ImagesSearchRepository {

        func searchImages(with query: Image, page: Int, completion: @escaping (Result<Image, String?>) -> Void) {
            completion(Result.failure("Data Invalid"))
        }
    }
    
    func testSearchImageUseCase_whenImagesAreSuceessfullytFetched() {
        // given
       let expectation = self.expectation(description: "Recent query should not be saved")
       expectation.expectedFulfillmentCount = 1

        let useCase = DefaultImagesSearchUseCase(imagesSearchRepository: ImageSearchRepoSuccessMock())
        useCase.searchImages(with: ImageSearchUseCaseTest.imageObject, page: 1) { result in
            switch result {
            case .success(let images):
                XCTAssertEqual(images.count, 2)
                expectation.fulfill()
            default: break
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchImageUseCase_whenImagesAreSuceessfullytFetched_withEmptyData() {
        // given
       let expectation = self.expectation(description: "Recent query should not be saved")
       expectation.expectedFulfillmentCount = 1

        let useCase = DefaultImagesSearchUseCase(imagesSearchRepository: ImageSearchRepoSuccessMock())
        useCase.searchImages(with: ImageSearchUseCaseTest.imageObjectEmpty, page: 1) { result in
            switch result {
            case .success(let images):
                XCTAssertEqual(images.count, 0)
                expectation.fulfill()
            default: break
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchImageUseCase_whenImagesAreFailed() {
        // given
       let expectation = self.expectation(description: "Recent query should not be saved")
       expectation.expectedFulfillmentCount = 1

        let useCase = DefaultImagesSearchUseCase(imagesSearchRepository: ImageSearchRepoFailureMock())
        useCase.searchImages(with: ImageSearchUseCaseTest.imageObject, page: 1) { result in
            switch result {
            case .failure(let errorMessage):
                XCTAssertNotNil(errorMessage)
                XCTAssertEqual(errorMessage, "Data Invalid")
                expectation.fulfill()
            default: break
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /*
     func testSearchMoviesUseCase_whenSuccessfullyFetchesMoviesForQuery_thenQueryIsSavedInRecentQueries() {
         // given
         let expectation = self.expectation(description: "Recent query saved")
         expectation.expectedFulfillmentCount = 2
         let moviesQueriesRepository = MoviesQueriesRepositoryMock()
         let useCase = DefaultSearchMoviesUseCase(moviesRepository: MoviesRepositorySuccessMock(),
                                                   moviesQueriesRepository: moviesQueriesRepository)

         // when
         let requestValue = SearchMoviesUseCaseRequestValue(query: MovieQuery(query: "title1"),
                                                                                      page: 0)
         _ = useCase.execute(requestValue: requestValue) { _ in
             expectation.fulfill()
         }
         // then
         var recents = [MovieQuery]()
         moviesQueriesRepository.recentsQueries(number: 1) { result in
             recents = (try? result.get()) ?? []
             expectation.fulfill()
         }
         waitForExpectations(timeout: 5, handler: nil)
         XCTAssertTrue(recents.contains(MovieQuery(query: "title1")))
     }
     */
}
