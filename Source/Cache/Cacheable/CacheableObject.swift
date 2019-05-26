//
//  CacheableObject.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

class CacheableObject: NSObject, NSCoding {
    
    //Vars
    let object: Cacheable?
    
    init(object: Cacheable) {
        
        self.object = object
        
    }
    
    //Create respective object from the type
    required init?(coder decoder: NSCoder) {
        
        guard let rawData = decoder.decodeObject(forKey: "rawData") as? Data,
            let namespace = Bundle(for: CacheableObject.self).infoDictionary!["CFBundleExecutable"] as? String,
            let type = decoder.decodeObject(forKey: "type") as? String else {
                
                object = nil
                return
                
        }
        
        object = (NSClassFromString("\(namespace).\(type)") as? Cacheable.Type)?.init(rawData: rawData)
        
    }
    
    //Encode both object and its type
    func encode(with coder: NSCoder) {
        
        guard let object = object else {
            return
        }
        
        coder.encode(object.rawData, forKey: "rawData")
        coder.encode("\(type(of: object))", forKey: "type")
        
    }
    
}
