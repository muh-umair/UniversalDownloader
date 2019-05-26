//
//  ImageResponse.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import UIKit

public class ImageResponse: Response {
    
    //Computed properties
    public var image: UIImage? {
        return UIImage(data: rawData)
    }
    
}

//MARK: - //MARK: - Request extension to set Image response type
extension Request {
    
    public typealias ImageRequestCompletionBlock = (Bool, String?, ImageResponse?)->Void
    
    public func responseImage(completion: @escaping ImageRequestCompletionBlock) {
        
        response(type: ImageResponse.self, completion: { (status, errorMessage, response) in
            completion(status, errorMessage, response as? ImageResponse)
        })
        
    }
    
    public func responseImage(in imageView: UIImageView, placeholder: UIImage? = nil, failure: UIImage? = nil) {
        
        //Apply placeholder if provided
        if placeholder != nil {
            imageView.image = placeholder
        }
        
        response(type: ImageResponse.self, completion: {[weak imageView] (status, errorMessage, response) in
            
            //If failed to get image then return
            guard status, let image = (response as? ImageResponse)?.image else {
                //Apply failure image if provided
                if failure != nil {
                    imageView?.image = failure
                }
                return
            }
            
            //Apply actual image
            imageView?.image = image
            
        })
    }
    
}

