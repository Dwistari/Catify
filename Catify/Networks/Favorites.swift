//
//  Favorites.swift
//  Catify
//
//  Created by Dwistari on 06/05/25.
//

import Foundation

struct Favorite: Codable {
    let id: Int
    let userID: String
    let imageID: String
    let subID: String?
    let createdAt: String
    let image: CatImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case imageID = "image_id"
        case subID = "sub_id"
        case createdAt = "created_at"
        case image
    }
}

struct CatImage: Codable {
    // You can add fields here later based on the real structure of the image object
}


struct FavoriteRequestBody: Codable {
    let imageID: String
    let subID: String
    
    enum CodingKeys: String, CodingKey {
        case imageID = "image_id"
        case subID = "sub_id"
    }
}

struct FavoriteResponse: Codable {
    let message: String
    let id: Int
}
