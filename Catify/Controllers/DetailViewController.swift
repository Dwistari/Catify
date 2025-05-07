//
//  DetailViewController.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import UIKit
import SDWebImage


class DetailViewController: BaseViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgCat: UIImageView!
    @IBOutlet weak var originLbl: UILabel!
    @IBOutlet weak var tempramentLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    private var cat: Cat
    private var viewModel = DetailViewModel()
    
    init(cat: Cat) {
        self.cat = cat
        self.viewModel = DetailViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail"
        loadData()
    }
    
    private func loadData() {
        self.showLoading()
        bindViewModel()
        viewModel.fetchDetail(id: cat.id)
    }
    
    private func bindViewModel() {
        viewModel.onSuccessFetchDetail = { [weak self] in
            guard let self = self, let data = self.viewModel.cat else { return }
            DispatchQueue.main.async {
                self.hideLoading()
                self.bindData(data: data)
            }
        }
        
        viewModel.onError = { [weak self] msg in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.hideLoading()
                self.showToastError(message: msg)
            }
        }
    }
    
    private func bindData(data: Cat) {
        imgCat.layer.cornerRadius = 8
        if let breed = data.breeds {
            nameLbl.text = breed.first?.name
            originLbl.text = breed.first?.origin
            tempramentLbl.text = breed.first?.temperament
            descriptionLbl.text = breed.first?.description
        } else {
            nameLbl.isHidden = true
            originLbl.isHidden = true
            descriptionLbl.isHidden = true
            tempramentLbl.text =  "No available data"
        }
   
        if let url = URL(string: data.url) {
            imgCat.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"), options: [.retryFailed, .continueInBackground])
        }
    }
}
