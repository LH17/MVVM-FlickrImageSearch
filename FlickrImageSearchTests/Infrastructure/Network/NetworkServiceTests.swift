//
//  NetworkServiceTests.swift
//  FlickrImageSearchTests
//
//  Created by lubaba on 3/13/20.
//  Copyright © 2020 lubaba. All rights reserved.
//

import XCTest

class NetworkServiceTests: XCTestCase {
    
    /*
     func test_whenMockDataPassed_shouldReturnProperResponse() {
         //given
         let config = NetworkConfigurableMock()
         let expectation = self.expectation(description: "Should return correct data")
         
         let expectedResponseData = "Response data".data(using: .utf8)!
         let sut = DefaultNetworkService(config: config,
                                         sessionManager: NetworkSessionManagerMock(response: nil,
                                                                                   data: expectedResponseData,
                                                                                   error: nil))
         //when
         _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
             guard let responseData = try? result.get() else {
                 XCTFail("Should return proper response")
                 return
             }
             XCTAssertEqual(responseData, expectedResponseData)
             expectation.fulfill()
         }
         //then
         wait(for: [expectation], timeout: 0.1)
     }
     */
}
