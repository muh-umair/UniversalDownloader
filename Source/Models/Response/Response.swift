//
//  Response.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

public class Response: Cacheable {
    
    //Vars
    public let rawData: Data
    
    //Initializer
    required init(rawData: Data) {
        self.rawData = rawData
    }
    
}
