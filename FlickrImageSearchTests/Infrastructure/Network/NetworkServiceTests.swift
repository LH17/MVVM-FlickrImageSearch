//
//  NetworkServiceTests.swift
//  FlickrImageSearchTests
//
//  Created by lubaba on 3/13/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import XCTest

class NetworkServiceTests: XCTestCase {
    
    private struct EndpointMock: Requestable {
        
        var path: String = ""
        var queryParameters: [String: Any] = [:]
        
        init(path: String, queryParameters: [String: Any]) {
            self.path = path
            self.queryParameters = queryParameters
        }
        
        func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
            return URLRequest(url: URL(string: "https://api.flickr.com/")!)
        }
    }
    
    private struct EndpointErrorMock: Requestable {
        
        var path: String = ""
        var queryParameters: [String: Any] = [:]
        
        init(path: String, queryParameters: [String: Any]) {
            self.path = path
            self.queryParameters = queryParameters
        }
        
        func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
            throw NetworkError.error(statusCode: -1, data: "URL Error".data(using: .utf8))
        }
    }
    
    func test_whenMockDataPassed_shouldReturnProperResponse() {
        //given
       
        let config: NetworkConfigurable = NetworkConfigurableMock(url: URL(string: "https://api.flickr.com/")!)
        let expectation = self.expectation(description: "Should return correct data")
        
        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                  data: expectedResponseData,
                                                                                  error: nil))
        //when
        _ = sut.request(endpoint: EndpointMock(path: "https://api.flickr.com", queryParameters: [:])) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData, expectedResponseData)
            case .failure(_):
                XCTFail("Should return proper response")
            }
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenMockDataPassed_shouldReturnError() {
        //given
       
        let config: NetworkConfigurable = NetworkConfigurableMock(url: URL(string: "https://api.flickr.com/")!)
        let expectation = self.expectation(description: "Should return correct data")
        
        let errorResponseData = NetworkError.error(statusCode: 500, data: nil)
        let expectedResponse = HTTPURLResponse.init()
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: expectedResponse,
                                                                                  data: nil,
                                                                                  error: errorResponseData))
        //when
        _ = sut.request(endpoint: EndpointMock(path: "https://api.flickr.com", queryParameters: [:])) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, errorResponseData.localizedDescription)
            }
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenMockDataPassed_shouldReturnInvalidUrlError() {
        //given
       
        let config: NetworkConfigurable = NetworkConfigurableMock(url: URL(string: "https://api.flickr.com/")!)
        let expectation = self.expectation(description: "Should return correct data")
        
        let errorResponseData = NetworkError.error(statusCode: -1, data: "URL Error".data(using: .utf8))
        let expectedResponse = HTTPURLResponse.init()
        let sut = DefaultNetworkService(config: config,
                                        sessionManager: NetworkSessionManagerMock(response: expectedResponse,
                                                                                  data: nil,
                                                                                  error: errorResponseData))
        //when
        _ = sut.request(endpoint: EndpointErrorMock(path: "", queryParameters: [:])) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, errorResponseData.localizedDescription)
            }
            expectation.fulfill()
        }
        //then
        wait(for: [expectation], timeout: 0.1)
    }
}
