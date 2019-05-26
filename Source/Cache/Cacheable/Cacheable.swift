//
//  Cacheable.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

protocol Cacheable {
    
    var rawData: Data { get }
    init(rawData: Data)
    
}
