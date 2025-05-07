//
//  Endpoints.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import Foundation

struct Endpoints {
    static let baseURL = "https://api.thecatapi.com/v1"

    struct Cats {
        static let list = "\(baseURL)/images/search"
        static let breeds = "\(baseURL)/breeds"

        static func details(id: String) -> String {
            return "\(baseURL)/images/\(id)"
        }
    }
}
