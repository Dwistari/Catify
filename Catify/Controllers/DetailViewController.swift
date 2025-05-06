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
        viewModel.fetchDetail(id: cat.id)
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onSuccessFetchDetail = { [weak self] in
            guard let self = self, let data = self.viewModel.cat else { return }
            DispatchQueue.main.async {
                self.hideLoading()
                self.bindData(data: data)
            }
        }
    }
    
    private func bindData(data: Cat) {
        nameLbl.text = data.breeds?.first?.name
        originLbl.text = data.breeds?.first?.origin
        tempramentLbl.text = data.breeds?.first?.temperament
        descriptionLbl.text = data.breeds?.first?.description
        
        if let url = URL(string: data.url) {
            imgCat.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"), options: [.retryFailed, .continueInBackground])
        }
    }
}
