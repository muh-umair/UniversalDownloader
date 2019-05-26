//
//  ResponseUtilsTests.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import XCTest

@testable import UniversalDownloader

class ResponseUtilsTests: XCTestCase {
    
}

//MARK: - Tests
extension ResponseUtilsTests {
    
    func testCacheableDataCreationSuccess() {
        
        //arrange
        let mockData = "Univeral Downloader".data(using: .utf8)!
        let mockResponse = Response(rawData: mockData)
        
        //act
        let cacheableData = ResponseUtils.toCacheableData(response: mockResponse)
        
        //assert
        XCTAssertNotNil(cacheableData)
        
    }
    
    func testResponseCreationSuccess() {
        
        //arrange
        let mockData = "Univeral Downloader".data(using: .utf8)!
        let mockResponse = Response(rawData: mockData)
        let mockCacheableData = try! NSKeyedArchiver.archivedData(withRootObject: CacheableObject(object: mockResponse), requiringSecureCoding: false)
        
        //act
        let response = ResponseUtils.toResponse(cacheableData: mockCacheableData)
        
        //assert
        XCTAssertNotNil(response)
        
    }
    
}
