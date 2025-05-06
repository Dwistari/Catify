//
//  CatViewCell.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import SDWebImage

class CatViewCell: UITableViewCell {
    
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var onTapFavorite: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1
    }
    
    
    func setupCell(cat: Cat){
        catLbl.text = cat.id
        let url = URL(string: cat.url)
        catImage.sd_setImage(with: url,placeholderImage: UIImage(systemName: "photo"), options: [.retryFailed, .continueInBackground])
    }
    
    @IBAction func tapFavorite(_ sender: Any) {
        self.onTapFavorite?()
    }
    
    
}
