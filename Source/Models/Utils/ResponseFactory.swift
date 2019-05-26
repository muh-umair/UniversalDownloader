//
//  ResponseFactory.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

class ResponseFactory {
    
    //Factory method to create response based on type or mimetype
    static func createResponse(withData data: Data, mimeType: String?, responseType: Response.Type?) -> Response {
        
        var response: Response
        
        if responseType != nil {
            
            response = responseType!.init(rawData: data)
            
        }else if mimeType?.hasPrefix("image/") == true {
            
            response = ImageResponse(rawData: data)
            
        }else if mimeType?.hasSuffix("/json") == true {
            
            response = JSONResponse(rawData: data)
            
        }else {
            
            response = Response(rawData: data)
            
        }
        
        return response
        
    }
    
}
