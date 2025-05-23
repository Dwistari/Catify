//
//  HomeViewController.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import UIKit

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var tableView: UITableView!
  
    private let viewModel = HomeViewModel()
    private var isLoading = false
    private var breeds: [Breed] = []
    private var cats: [Cat] = []
    private var favoriteCats: [Cat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        loadData()
    }

    private func setupView() {
        self.title = "Home"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "CatViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CatViewCell")
        
        btnFavorite.layer.borderWidth = 1
        btnFavorite.layer.borderColor = UIColor.gray.cgColor
        btnFavorite.layer.cornerRadius = 8
    }
    
    
    private func loadData() {
        self.showLoading()
        viewModel.fetchCats()
        viewModel.fetchBreeds()
    }

    private func bindViewModel() {
        viewModel.onSuccessFetchCats = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.cats = self.viewModel.cats
                self.tableView.reloadData()
                self.isLoading = false
                self.tableView.tableFooterView = nil
                self.hideLoading()
            }
        }
        
        viewModel.onSuccessFetchBreeds = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoading()
                self.breeds = self.viewModel.breeds
                self.tableView.reloadData()
            }
        }

        viewModel.onError = { [weak self] msg in
            guard let self = self else {return}
            self.hideLoading()
            self.showToastError(message: msg)
        }
        favoriteCats = CoreDataManager.shared.fetchFavorites()
    }
    
    
    @IBAction func chooseFav(_ sender: Any) {
        let vc = FavoriteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func chooseFilter(_ sender: Any) {
        let filterVC = BreedFilterViewController(nibName: "BreedFilterViewController", bundle: nil)
        filterVC.breeds =  self.breeds
        filterVC.delegate = self
        present(filterVC, animated: true)
    }
    
    private func createTableFooterSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = footerView.center
        spinner.startAnimating()
        footerView.addSubview(spinner)
        return footerView
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatViewCell", for: indexPath) as? CatViewCell else {
            return UITableViewCell()
        }
        
        let cat =  cats[indexPath.row]
        let isFavorited = favoriteCats.contains { $0.id == cat.id }
        let imageName = isFavorited ? "heart.fill" : "heart"
        cell.favoriteBtn.setImage(UIImage(systemName: imageName), for: .normal)
        
        cell.setupCell(cat: cat)
        cell.onTapFavorite = { [weak self] in
            guard let self = self else { return }
            CoreDataManager.shared.saveFavorite(isFavorite: !isFavorited, cat: cat)
            
            // Refresh favorites and reload cell
            self.favoriteCats = CoreDataManager.shared.fetchFavorites()
            self.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController(cat: viewModel.cats[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 1.5 && !isLoading && viewModel.hasMoreData {
            isLoading = true
            self.tableView.tableFooterView = createTableFooterSpinner()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else {return}
                self.viewModel.page += 1
                self.viewModel.fetchCats()
                self.viewModel.onSuccessFetchCats = { [weak self] in
                    guard let self = self else {return}
                    DispatchQueue.main.async {
                        self.cats = self.viewModel.cats
                        self.isLoading = false
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
 
}

extension HomeViewController: BreedFilterDelegate {
    func didSelectBreed(_ breed: Breed) {
        self.showLoading()
        viewModel.filterByBreed(breed: breed.id )
        bindViewModel()
    }
}
