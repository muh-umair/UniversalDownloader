//
//  ImageCategory.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import ObjectMapper

class ImageCategory: ImmutableMappable {
    
    let id: Int
    let title: String
    let photosCount: Int
    
    let selfUrl: String
    let photosUrl: String
    
    required init(map: Map) throws {
        
        id = (try? map.value("id")) ?? 0
        title = (try? map.value("title")) ?? ""
        photosCount = (try? map.value("photo_count")) ?? 0
        
        selfUrl = (try? map.value("links.self")) ?? ""
        photosUrl = (try? map.value("links.photos")) ?? ""
        
    }
    
    func mapping(map: Map) {
        
        id >>> map["id"]
        title >>> map["title"]
        photosCount >>> map["photo_count"]
        
        selfUrl >>> map["links.self"]
        photosUrl >>> map["links.photos"]
        
    }
    
}

