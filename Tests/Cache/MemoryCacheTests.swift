//
//  MemoryCacheTests.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import XCTest

@testable import UniversalDownloader

class MemoryCacheTests: XCTestCase {
    
    //SUT
    private var cache: MemoryCache!
    
    //Setup & Teardown
    override func setUp() {
        
        super.setUp()
        
        cache = MemoryCache(capacity: 10 * 1024)
        
    }
    
    override func tearDown() {
        
        cache = nil
        
        super.tearDown()
        
    }
    
}

//MARK: - Tests
extension MemoryCacheTests {
    
    func testObjectCachedSuccess() {
        
        //arrange
        let mockString = "Universal Dowloader"
        let mockObject = mockString.data(using: .utf8)!
        
        //act
        cache.save(data: mockObject, forKey: "obj")
        let cacheObject = cache.get(forKey: "obj")
        
        //assert
        XCTAssertNotNil(cacheObject)
        
        let cacheString = String(data: cacheObject!, encoding: .utf8)
        XCTAssertNotNil(cacheString)
        XCTAssertEqual(cacheString, mockString)
        
    }
    
    func testCapacityChange() {
        
        //arrange
        let previousCapacity = cache.capacity
        
        //act
        cache.capacity = previousCapacity * 2
        let newCapacity = cache.capacity
        
        //assert
        XCTAssertNotEqual(previousCapacity, newCapacity)
        XCTAssertEqual(newCapacity, previousCapacity * 2)
        
    }
    
}

