//
//  MemoryCache.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

class MemoryCache: Cache {
    
    //Vars
    private var cache: NSCache<NSString, NSData>
    
    var capacity: Int {
        get {
            return cache.totalCostLimit
        }
        set {
            cache.totalCostLimit = newValue
        }
    }
    
    //Initializer
    required init(capacity: Int) {
        
        cache = NSCache()
        self.capacity = capacity
        
    }
    
}

//MARK: - Methods for caching
extension MemoryCache {
    
    func save(data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
    
}
