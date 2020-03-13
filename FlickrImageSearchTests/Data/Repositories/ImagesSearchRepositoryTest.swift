//
//  ImagesSearchRepositoryTest.swift
//  FlickrImageSearchTests
//
//  Created by lubaba on 3/12/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import XCTest

class ImagesSearchRepositoryTest: XCTestCase {
    
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
    
    class NetworkConfigurableMock: NetworkConfigurable {
        var baseURL: URL
        init(url: URL) {
            self.baseURL = url
        }
    }
    
    class NetwrokServiceSuccessMock: NetworkService {
        var config: NetworkConfigurable = NetworkConfigurableMock(url: URL(string: "https://api.flickr.com/")!)
        
        func request(endpoint: Requestable, completion: @escaping CompletionHandler) {
            let string = """
                {
                  "photos": {
                    "page": 1,
                    "pages": 1663,
                    "perpage": 100,
                    "total": "166300",
                    "photo": []
                }
                }
                """
            let data = Data(string.utf8)
            completion(Result.success(data))
        }
    }
    
    class NetwrokServiceNilDataMock: NetworkService {
        var config: NetworkConfigurable = NetworkConfigurableMock(url: URL(string: "https://api.flickr.com/")!)
        
        func request(endpoint: Requestable, completion: @escaping CompletionHandler) {
            completion(Result.success(nil))
        }
    }
    
    class NetwrokServiceErrorDataMock: NetworkService {
        var config: NetworkConfigurable = NetworkConfigurableMock(url: URL(string: "https://api.flickr.com/")!)
        
        func request(endpoint: Requestable, completion: @escaping CompletionHandler) {
            let string = """
                {
                  "photos": {
                    "page": 1,
                    "pages": 1663,
                    "perpage": 100,
                    "total": "166300",
                    "photo": []
                """
            let data = Data(string.utf8)
            completion(Result.success(data))
        }
    }
    
    class NetwrokServiceNilFailureMock: NetworkService {
        var config: NetworkConfigurable = NetworkConfigurableMock(url: URL(string: "https://api.flickr.com/")!)
        
        func request(endpoint: Requestable, completion: @escaping CompletionHandler) {
            completion(Result.failure(NetworkError.error(statusCode: 500, data: nil)))
        }
    }
    
    func testSearchImagesRepository_whenImagesAreSuceessfullytFetchedAndParsed() {
        // given
        let expectation = self.expectation(description: "whenImagesAreSuceessfullytFetched")
        expectation.expectedFulfillmentCount = 1
        
        let repo = DefaultImagesSearchRepository(networkService: NetwrokServiceSuccessMock())
        repo.searchImages(with: ImagesSearchRepositoryTest.imageObject, page: 1) { result in
            switch result {
            case .success(let jsonData):
                XCTAssertNotNil(jsonData)
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchImagesRepository_whenImageDatafailedToBeParsed() {
        // given
        let expectation = self.expectation(description: "whenImagesFailedToParse")
        expectation.expectedFulfillmentCount = 1
        
        let repo = DefaultImagesSearchRepository(networkService: NetwrokServiceNilDataMock())
        repo.searchImages(with: ImagesSearchRepositoryTest.imageObject, page: 1) { result in
            switch result {
            case .failure(let errorMessage):
                XCTAssertEqual("Data is incorrect", errorMessage)
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchImagesRepository_whenImageDataIsMalformed() {
        // given
        let expectation = self.expectation(description: "whenImagesFailedToParse")
        expectation.expectedFulfillmentCount = 1
        
        let repo = DefaultImagesSearchRepository(networkService: NetwrokServiceErrorDataMock())
        repo.searchImages(with: ImagesSearchRepositoryTest.imageObject, page: 1) { result in
            switch result {
            case .failure(let errorMessage):
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchImagesRepository_whenImageDataFailedToBeFetched() {
        // given
        let expectation = self.expectation(description: "whenImageDataFailedToBeFetched")
        expectation.expectedFulfillmentCount = 1
        
        let repo = DefaultImagesSearchRepository(networkService: NetwrokServiceNilFailureMock())
        repo.searchImages(with: ImagesSearchRepositoryTest.imageObject, page: 1) { result in
            switch result {
            case .failure(let errorMessage):
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
