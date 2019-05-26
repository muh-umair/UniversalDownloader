//
//  UniversalDownloader.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 24/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

public class UniversalDownloaderConfigs {
    
    public class var `default`: UniversalDownloaderConfigs {
        return UniversalDownloaderConfigs(cacheType: .memory, maxConcurrentRequest: 10)
    }
    
    let cacheType: CacheType
    let cacheCapacity: Int
    let maxConcurrentRequest: Int
    
    public init(cacheType: CacheType, maxConcurrentRequest: Int, cacheCapacity: Int = 50 * 1024) {
        
        self.cacheType = cacheType
        self.cacheCapacity = cacheCapacity
        self.maxConcurrentRequest = maxConcurrentRequest
        
    }
    
    func getCache() -> Cache {
        return CacheFactory.createCache(ofType: cacheType, withCapacity: cacheCapacity)
    }
    
}

public class UniversalDownloader {
    
    public static let shared = UniversalDownloader(configs: UniversalDownloaderConfigs.default)
  
    //Private vars
    private let downloadQueue: OperationQueue
    private var cache: Cache
    
    private var getResponseFromCache: GetResponseFromCacheBlock!
    private var setResponseInCache: SetResponseInCacheBlock!
    private var startRequest: StartRequestBlock!
    
    //Initializer
    public init(configs: UniversalDownloaderConfigs) {
        
        downloadQueue = OperationQueue()
        downloadQueue.maxConcurrentOperationCount = configs.maxConcurrentRequest
        
        cache = configs.getCache()
        
        getResponseFromCache = nil
        setResponseInCache = nil
        startRequest = nil
        
        //Callbacks for request to access downloader
        getResponseFromCache = { [weak self] (key: String) -> Response? in
        
            guard let data = self?.cache.get(forKey: key),
                let response = ResponseUtils.toResponse(cacheableData: data) else {
                return nil
            }
            
            return response
            
        }
        
        setResponseInCache = { [weak self] (key: String, response: Response) in
            
            guard let data = ResponseUtils.toCacheableData(response: response) else {
                return
            }
            
            self?.cache.save(data: data, forKey: key)
            
        }
        
        startRequest = { [weak self] (request: Request) in
            
            self?.downloadQueue.addOperation(request)
            
        }
        
    }
    
}

//MARK: - Public methods
extension UniversalDownloader {
    
    public func request(url: String) -> Request {
        return Request(url: url, getResponseFromCacheBlock: getResponseFromCache, setResponseInCacheBlock: setResponseInCache, startRequestBlock: startRequest)
    }
    
    public func cancelAll() {
        downloadQueue.cancelAllOperations()
    }
    
    public func currentCacheCapacity() -> Int {
        return cache.capacity
    }
    
    public func updateCacheCapacity(newCapacity: Int) {
        cache.capacity = newCapacity
    }
    
}
