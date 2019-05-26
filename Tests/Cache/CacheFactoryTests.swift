//
//  CacheFactoryTests.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import XCTest

@testable import UniversalDownloader

class CacheFactoryTests: XCTestCase {
    
}

//MARK: - Tests
extension CacheFactoryTests {
    
    func testMemoryCacheCreationSuccess() {
        
        //arrange
        let cacheType = CacheType.memory
        let cacheCapacity = 1024
        
        //act
        let cache = CacheFactory.createCache(ofType: cacheType, withCapacity: cacheCapacity)
        
        //assert
        XCTAssertTrue(cache is MemoryCache)
        XCTAssertEqual(cache.capacity, cacheCapacity)
        
    }
    
}


