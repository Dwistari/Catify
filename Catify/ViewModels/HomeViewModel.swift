//
//  HomeViewModel.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import Foundation

class HomeViewModel {
    private let service: CatServiceProtocol
    var cats: [Cat] = []
    var breeds: [Breed] = []

    var selectedBreed: String = ""
    var onSuccessFetchCats: (() -> Void)?
    var onSuccessFetchBreeds: (() -> Void)?
    var onSuccessAddfavorite: (() -> Void)?
    var onError: ((String) -> Void)?

    var page = 0
    var hasMoreData = true

    init(service: CatServiceProtocol = CatService()) {
        self.service = service
    }

    func fetchCats() {
        guard hasMoreData else { return }
        service.fetchCats(page: page,breed: selectedBreed) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let newCats):
                if newCats.isEmpty {
                    self.hasMoreData = false
                    self.onSuccessFetchCats?()
                } else {
                    if self.page > 0 {
                        self.cats.append(contentsOf: newCats)
                    } else {
                        self.cats = newCats
                    }
                    self.page += 1
                    self.onSuccessFetchCats?()
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    func fetchBreeds() {
        service.fetchBreeds { [weak self] result in
            switch result {
            case .success(let breeds):
                self?.breeds.append(contentsOf: breeds)
                self?.onSuccessFetchBreeds?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func filterByBreed(breed: String) {
        selectedBreed = breed
        page = 0
        hasMoreData = true
        fetchCats()
    }
}
