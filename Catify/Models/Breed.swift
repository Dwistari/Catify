//
//  Breed.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import Foundation

struct Breed: Codable {
    let id: String
    let name: String
    let origin: String?
    let temperament: String?
    let description: String?
    let life_span: String?
}
