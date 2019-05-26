//
//  User.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import ObjectMapper

class User: ImmutableMappable {
    
    let id: String
    let userName: String
    let name: String
    
    let profileImageSmallUrl: String
    let profileImageMediumUrl: String
    let profileImageLargeUrl: String
    
    let selfUrl: String
    let htmlUrl: String
    let photosUrl: String
    let likesUrl: String
    
    required init(map: Map) throws {
        
        id = (try? map.value("id")) ?? ""
        userName = (try? map.value("username")) ?? ""
        name = (try? map.value("name")) ?? ""
        
        profileImageSmallUrl = (try? map.value("profile_image.small")) ?? ""
        profileImageMediumUrl = (try? map.value("profile_image.medium")) ?? ""
        profileImageLargeUrl = (try? map.value("profile_image.large")) ?? ""
        
        selfUrl = (try? map.value("links.self")) ?? ""
        htmlUrl = (try? map.value("links.html")) ?? ""
        photosUrl = (try? map.value("links.photos")) ?? ""
        likesUrl = (try? map.value("links.likes")) ?? ""
        
    }
    
    func mapping(map: Map) {
        
        id >>> map["id"]
        userName >>> map["username"]
        name >>> map["name"]
        
        profileImageSmallUrl >>> map["profile_image.small"]
        profileImageMediumUrl >>> map["profile_image.medium"]
        profileImageLargeUrl >>> map["profile_image.large"]
        
        selfUrl >>> map["links.self"]
        htmlUrl >>> map["links.html"]
        photosUrl >>> map["links.photos"]
        likesUrl >>> map["links.likes"]
        
    }
    
}
