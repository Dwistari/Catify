//
//  Cat.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import Foundation

struct Cat: Codable {
    let id: String
    let url: String
    let breeds: [Breed]?
}

