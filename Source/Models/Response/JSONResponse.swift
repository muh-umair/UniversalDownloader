//
//  JSONResponse.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

public class JSONResponse: Response {
    
    //Computed properties
    public var json: Any? {
        return try? JSONSerialization.jsonObject(with: rawData)
    }
    
    public var dictionary:[String: AnyObject]? {
        return json as? [String: AnyObject]
    }
    
    public var array:[AnyObject]? {
        return json as? [AnyObject]
    }
    
}

//MARK: - Request extension to set JSON response type
extension Request {
    
    public typealias JSONRequestCompletionBlock = (Bool, String?, JSONResponse?)->Void
    
    public func responseJSON(completion: @escaping JSONRequestCompletionBlock) {
        
        response(type: JSONResponse.self, completion: { (status, errorMessage, response) in
            completion(status, errorMessage, response as? JSONResponse)
        })
        
    }
    
}

