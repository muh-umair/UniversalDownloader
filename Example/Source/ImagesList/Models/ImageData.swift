//
//  ImageData.swift
//  UniversalDownloader
//
//  Created by Umair Bhatti on 25/05/2019.
//  Copyright © 2019 MindValley. All rights reserved.
//

import ObjectMapper

class ImageData: ImmutableMappable {
    
    let id: String
    let createAt: Date
    
    let width: Int
    let height: Int
    
    let color: UIColor
    let likes: Int
    let likedByUser: Bool
    
    let rawUrl: String
    let fullUrl: String
    let regularUrl: String
    let smallUrl: String
    let thumbUrl: String
    
    let selfUrl: String
    let htmlUrl: String
    let downloadUrl: String
    
    let user: User?
    let categories: [ImageCategory]
    let currentUserCollections: [String]
    
    required init(map: Map) throws {
        
        id = (try? map.value("id")) ?? ""
        createAt = (try? map.value("created_at", using: DateTransform(format: "yyyy-MM-dd'T'HH:mm:ssXXXXX"))) ?? Date(timeIntervalSince1970: 0)

        width = (try? map.value("width")) ?? 0
        height = (try? map.value("height")) ?? 0
        
        color = (try? map.value("color", using: HexColorTransform())) ?? UIColor.clear
        likes = (try? map.value("likes")) ?? 0
        likedByUser = (try? map.value("liked_by_user")) ?? false
        
        rawUrl = (try? map.value("urls.raw")) ?? ""
        fullUrl = (try? map.value("urls.full")) ?? ""
        regularUrl = (try? map.value("urls.regular")) ?? ""
        smallUrl = (try? map.value("urls.small")) ?? ""
        thumbUrl = (try? map.value("urls.thumb")) ?? ""
        
        selfUrl = (try? map.value("links.self")) ?? ""
        htmlUrl = (try? map.value("links.html")) ?? ""
        downloadUrl = (try? map.value("links.download")) ?? ""
        
        user = try? map.value("user")
        categories = (try? map.value("categories")) ?? []
        currentUserCollections = (try? map.value("current_user_collections")) ?? []
        
    }
    
    func mapping(map: Map) {
        
        id >>> map["id"]
        createAt >>> (map["created_at"], DateTransform(format: "yyyy-MM-dd'T'HH:mm:ssXXXXX"))
        
        width >>> map["width"]
        height >>> map["height"]
        
        color >>> (map["color"], HexColorTransform())
        likes >>> map["likes"]
        likedByUser >>> map["liked_by_user"]
        
        rawUrl >>> map["urls.raw"]
        fullUrl >>> map["urls.full"]
        regularUrl >>> map["urls.regular"]
        smallUrl >>> map["urls.small"]
        thumbUrl >>> map["urls.thumb"]
        
        selfUrl >>> map["links.self"]
        htmlUrl >>> map["links.html"]
        downloadUrl >>> map["links.download"]
        
        user >>> map["user"]
        categories >>> map["categories"]
        currentUserCollections >>> map["current_user_collections"]
        
    }
    
}

