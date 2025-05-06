//
//  FavoriteViewController.swift
//  Catify
//
//  Created by Dwistari on 06/05/25.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLbl: UILabel!
    private var favoriteCats: [Cat] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        favoriteCats = CoreDataManager.shared.fetchFavorites()
        showEmptyView()
    }


    private func setupTableView() {
        self.title = "Favorite"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "CatViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CatViewCell")
    }
    
    
    private func showEmptyView() {
        emptyLbl.isHidden = !favoriteCats.isEmpty
    }
    

}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatViewCell", for: indexPath) as? CatViewCell else {
            return UITableViewCell()
        }
        
        let cat =  favoriteCats[indexPath.row]
        cell.favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        cell.setupCell(cat: cat)
        cell.onTapFavorite = { [weak self] in
            guard let self = self else { return }
            CoreDataManager.shared.saveFavorite(isFavorite: false, cat: cat)
            
            // Refresh favorites and reload cell
            self.favoriteCats = CoreDataManager.shared.fetchFavorites()
            self.tableView.reloadData()
            self.showEmptyView()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
