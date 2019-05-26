//
//  Cache.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import Foundation

protocol Cache {
    
    var capacity: Int { get set }
    
    init(capacity: Int)
    func save(data: Data, forKey key: String)
    func get(forKey key: String) -> Data?
    
}
