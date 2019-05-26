//
//  Request.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

public typealias RequestCompletionBlock = (Bool, String?, Response?)->Void
public typealias CancelRequestCompletionBlock = ()->Void

typealias GetResponseFromCacheBlock = (String)->Response?
typealias SetResponseInCacheBlock = (String, Response)->Void
typealias StartRequestBlock = (Request)->Void

public class Request: BlockOperation {
    
    //Queue to access network synchronously
    private static let serialAccessQueue = DispatchQueue(label: "serialAccessQueue")
    
    //Private vars
    private let url: String
    
    private let getResponseFromCacheBlock: GetResponseFromCacheBlock
    private let setResponseInCacheBlock: SetResponseInCacheBlock
    private let startRequestBlock: StartRequestBlock
    
    private var responseType: Response.Type?
    private var requestCompletionBlock: RequestCompletionBlock?
    private var cancelRequestCompletionBlock: CancelRequestCompletionBlock?
    
    //Initializer
    init(url: String, getResponseFromCacheBlock: @escaping GetResponseFromCacheBlock, setResponseInCacheBlock: @escaping SetResponseInCacheBlock, startRequestBlock: @escaping StartRequestBlock) {
        
        self.url = url
        
        self.getResponseFromCacheBlock = getResponseFromCacheBlock
        self.setResponseInCacheBlock = setResponseInCacheBlock
        self.startRequestBlock = startRequestBlock
        
        super.init()
        
    }
    
}

//MARK: - Public methods to set different response types
extension Request {
    
    public func response(type: Response.Type? = nil, completion: @escaping RequestCompletionBlock) {
        
        responseType = type
        requestCompletionBlock = completion
        
        startRequestBlock(self)
        
    }
    
    public func cancel(completion: @escaping CancelRequestCompletionBlock) {
        
        cancelRequestCompletionBlock = completion
        cancel()
        
    }
    
}

//MARK: - Processing
extension Request {
    
    override public func cancel() {
        
        super.cancel()
        
        DispatchQueue.main.async {
            self.cancelRequestCompletionBlock?()
        }
        
    }
    
    override public func main() {
        
        //If cancelled then don't do anything
        guard !isCancelled else {
            return
        }
        
        //If already cached and the required object is same type then return, otherwise get from url
        if let response = getResponseFromCacheBlock(url), type(of: response) == responseType {
            DispatchQueue.main.async {
                self.requestCompletionBlock?(true, nil, response)
            }
            return
        }
        
        //If invalid url then return with message
        guard let requestURL = URL(string: url) else {
            DispatchQueue.main.async {
                self.requestCompletionBlock?(false, "Can't process now. Invalid URL.", nil)
            }
            return
        }
        
        //Sync access to network.
        Request.serialAccessQueue.sync {
            
            //If cancelled then don't do anything
            guard !isCancelled else {
                return
            }
            
            //If already cached and the required object is same type then return, otherwise get from url
            if let response = getResponseFromCacheBlock(url), type(of: response) == responseType {
                DispatchQueue.main.async {
                    self.requestCompletionBlock?(true, nil, response)
                }
                return
            }
            
            //Get data from url
            let (data, urlResponse, error) = URLSession.shared.synchronousDataTask(with: requestURL)
            
            //If cancelled then don't do anything
            guard !isCancelled else {
                return
            }
            
            //If there is an error then return with message
            guard data != nil, error == nil else {
                DispatchQueue.main.async {
                    self.requestCompletionBlock?(false, error?.localizedDescription ?? "Can't process now. Empty response.", nil)
                }
                return
            }
            
            //Create response object based on required response type or mime-type if no specific type required
            let response = ResponseFactory.createResponse(withData: data!, mimeType: urlResponse?.mimeType, responseType: responseType)
            
            //Put response in cache
            setResponseInCacheBlock(url, response)
            
            //Call the callback with updated response
            DispatchQueue.main.async {
                self.requestCompletionBlock?(true, nil, response)
            }
            
        }
        
    }
    
}
