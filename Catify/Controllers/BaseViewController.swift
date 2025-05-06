//
//  BaseViewController.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoading() {
        loadingIndicator.center = view.center
        loadingIndicator.color = .gray
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        view.isUserInteractionEnabled = false
    }

   func hideLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
}
