//
//  UniversalDownloaderTests.swift
//  UniversalDownloaderTests
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import XCTest

@testable import UniversalDownloader

class UniversalDownloaderTests: XCTestCase {
    
    //SUT
    private var downloader: UniversalDownloader!

    //Setup & Teardown
    override func setUp() {
        
        super.setUp()
        
        let mockConfigs = MockUniversalDownloaderConfigs()
        downloader = UniversalDownloader(configs: mockConfigs)
        
    }

    override func tearDown() {
        
        downloader = nil
        
        super.tearDown()
        
    }

}

//MARK: - Tests
extension UniversalDownloaderTests {
    
    func testResponseSuccess() {
        
        //arrange
        let url = "http://pastebin.com/raw/wgkJgazE"
        let promise = expectation(description: "Response received successfully")
        var status: Bool = false, errorMessage: String?, response: Response?
        
        //act
        downloader
            .request(url: url)
            .response { (_status, _errorMessage, _response) in
                
                status = _status
                errorMessage = _errorMessage
                response = _response
                
                promise.fulfill()
                
        }
        
        wait(for: [promise], timeout: 3.0)
        
        //assert
        XCTAssertTrue(status)
        XCTAssertNil(errorMessage)
        XCTAssertNotNil(response)
        
    }
    
    func testJSONResponseSuccess() {
        
        //arrange
        let url = "http://pastebin.com/raw/wgkJgazE"
        let promise = expectation(description: "JSON response received successfully")
        var status: Bool = false, errorMessage: String?, response: JSONResponse?
        
        //act
        downloader
            .request(url: url)
            .responseJSON { (_status, _errorMessage, _response) in
                
                status = _status
                errorMessage = _errorMessage
                response = _response
                
                promise.fulfill()
                
        }
        
        wait(for: [promise], timeout: 3.0)
        
        //assert
        XCTAssertTrue(status)
        XCTAssertNil(errorMessage)
        XCTAssertNotNil(response)
        XCTAssertNotNil(response?.array)
        
    }
    
    func testImageResponseSuccess() {
        
        //arrange
        let url = "https://images.unsplash.com/profile-1464495186405-68089dcd96c3"
        let promise = expectation(description: "Image response received successfully")
        var status: Bool = false, errorMessage: String?, response: ImageResponse?
        
        //act
        downloader
            .request(url: url)
            .responseImage { (_status, _errorMessage, _response) in
                
                status = _status
                errorMessage = _errorMessage
                response = _response
                
                promise.fulfill()
                
        }
        
        wait(for: [promise], timeout: 20.0)
        
        //assert
        XCTAssertTrue(status)
        XCTAssertNil(errorMessage)
        XCTAssertNotNil(response)
        XCTAssertNotNil(response?.image)
        
    }
    
    func testImageResponseInImageViewSuccess() {
        
        //arrange
        let url = "https://images.unsplash.com/profile-1464495186405-68089dcd96c3"
        let promise = expectation(description: "Image response received successfully")
        let mockImageView = UIImageView(frame: .zero)
        
        //act
        downloader
            .request(url: url)
            .responseImage(in: mockImageView, placeholder: nil, failure: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10.0)
        
        //assert
        XCTAssertNotNil(mockImageView.image)
        
    }

    func testRequestCancelSuccess() {
        
        //arrange
        let url = "http://pastebin.com/raw/wgkJgazE"
        var promises = [XCTestExpectation]()
        var successCount: Int = 0, requestsCount = 4
        
        //act
        for i in 0..<requestsCount {
            
            let promise = expectation(description: "Response received successfully")
            let req = downloader.request(url: url)
                
            req.response { (_status, _, _) in
                    
                if _status {
                    successCount += 1
                }
                promise.fulfill()
                
                
            }
            
            if i % 2 == 1 {//Cancel every odd request
                req.cancel {
                    promise.fulfill()
                }
            }
            
            promises.append(promise)
            
        }
        
        wait(for: promises, timeout: 10.0)
        
        //assert
        XCTAssertEqual(successCount, requestsCount / 2)
        
    }
    
    func testCapacityChange() {
        
        //arrange
        let previousCapacity = downloader.currentCacheCapacity()

        //act
        downloader.updateCacheCapacity(newCapacity: previousCapacity * 2)
        let newCapacity = downloader.currentCacheCapacity()
        
        //assert
        XCTAssertNotEqual(previousCapacity, newCapacity)
        XCTAssertEqual(newCapacity, previousCapacity * 2)
        
    }

}

//MARK: - Mocks
extension UniversalDownloaderTests {
    
    class MockCache: Cache {
        
        var capacity: Int
        
        required init(capacity: Int) {
            self.capacity = capacity
        }
        
        func save(data: Data, forKey key: String) {
            //No implementation required
        }
        
        func get(forKey key: String) -> Data? {
            return nil
        }
        
        func update(capacity: Int) {
            self.capacity = capacity
        }
        
    }
    
    class MockUniversalDownloaderConfigs: UniversalDownloaderConfigs {
        
        init() {
            super.init(cacheType: .memory, maxConcurrentRequest: 10)
        }
        
        override func getCache() -> Cache {
            return MockCache(capacity: 1024)
        }
        
    }
    
}
