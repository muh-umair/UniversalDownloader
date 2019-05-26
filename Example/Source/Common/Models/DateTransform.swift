//
//  DateTransform.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import ObjectMapper

class DateTransform: TransformType {
    
    typealias Object = Date
    typealias JSON = String
    
    private let format: String
    
    init(format: String) {
        self.format = format
    }
    
    func transformFromJSON(_ value: Any?) -> Object? {
        
        guard let str = value as? String else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: str)
        
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        
        guard let date = value else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
        
    }
    
}



