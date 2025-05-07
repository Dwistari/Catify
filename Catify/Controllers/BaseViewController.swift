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
    
    func showToastError(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        let textSize = toastLabel.intrinsicContentSize
        let labelWidth = min(textSize.width, self.view.frame.width - 40)
        
        toastLabel.frame = CGRect(
            x: self.view.frame.width / 2 - (labelWidth + 20) / 2,
            y: self.view.frame.height - 100,
            width: labelWidth + 20,
            height: textSize.height + 20
        )
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
