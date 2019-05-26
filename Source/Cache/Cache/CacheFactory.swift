//
//  CacheType.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

public enum CacheType {
    case memory
}

class CacheFactory {
    
    //Factory method to create differecnt cache clases based on type
    static func createCache(ofType type: CacheType, withCapacity capacity: Int) -> Cache {
     
        var cache: Cache
        
        switch type {
        case .memory:
            cache = MemoryCache(capacity: capacity)
        }
        
        return cache
        
    }
    
}
