//
//  CatService.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import Alamofire
import Foundation


protocol CatServiceProtocol {
    func fetchCats(page: Int, breed: String, completion: @escaping (Result<[Cat], AFError>) -> Void) 
    func fetchBreeds(completion: @escaping (Result<[Breed], AFError>) -> Void)
    func fetchDetail(id: String, completion: @escaping (Result<Cat, AFError>) -> Void)
}

class CatService: CatServiceProtocol {
    
    private let apiKey = "live_3oGTXh1kffzdAk3VZB9KHlZdv0TDoxpYve3eDhCbyftzLKbB8HSvefQfmTMH4ZeF"

    func fetchCats(page: Int, breed: String, completion: @escaping (Result<[Cat], AFError>) -> Void) {
        let headers: HTTPHeaders = [
            "x-api-key": apiKey
        ]
        
        let url = Endpoints.Cats.list
         var parameters: [String: Any] = [
             "limit": 10,
             "page": page,
             "order": "ASC"
         ]
         
         if !breed.isEmpty {
             parameters["breed_ids"] = breed
         }
   
        AF.request(url, parameters: parameters, headers: headers).responseDecodable(of: [Cat].self) { response in
            completion(response.result)
            
            if let request = response.request {
                  print("🐱 Full Request URL: \(request.url?.absoluteString ?? "nil")")
              }

        }
        
    }

    func fetchBreeds(completion: @escaping (Result<[Breed], AFError>) -> Void) {
        let url = Endpoints.Cats.breeds
        AF.request(url).responseDecodable(of: [Breed].self) { response in
            completion(response.result)
        }
    }
    
    func fetchDetail(id: String, completion: @escaping (Result<Cat, AFError>) -> Void) {
        let url = Endpoints.Cats.details(id: id)
        AF.request(url).responseDecodable(of: Cat.self) { response in
            completion(response.result)
        }  
        
        print("🐱 Full URL-----: \(url)")
    }
}
