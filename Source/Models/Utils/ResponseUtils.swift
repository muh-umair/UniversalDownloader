//
//  ResponseUtils.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

class ResponseUtils {
    
    //Methods to convert response in cacheable data
    static func toCacheableData(response: Response) -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: CacheableObject(object: response), requiringSecureCoding: false)
    }
    
    static func toResponse(cacheableData: Data) -> Response? {
        return (try? (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cacheableData) as? CacheableObject))??.object as? Response
    }
    
}
