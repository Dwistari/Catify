//
//  DetailViewModel.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import Foundation

class DetailViewModel {
    
    private let service: CatServiceProtocol
    var cat: Cat?
    
    var onSuccessFetchDetail: (() -> Void)?
    var onError: ((String) -> Void)?

    init(service: CatServiceProtocol = CatService()) {
        self.service = service
    }

    func fetchDetail(id: String) {
        service.fetchDetail(id: id) { [weak self] result in
            switch result {
            case .success(let cat):
                self?.cat = cat
                self?.onSuccessFetchDetail?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    

}
