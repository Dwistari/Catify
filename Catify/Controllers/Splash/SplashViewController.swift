//
//  SplashViewController.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import UIKit

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupLogo()
        navigateToNextScreen()
    }

    private func setupLogo() {
        let imageView = UIImageView(image: UIImage(named: "cat_icon_1024"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func navigateToNextScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            let isLoggedIn = SessionManager.shared.isLoggedIn
            let nextVC = isLoggedIn ? HomeViewController() : LoginViewController()
            let navController = UINavigationController(rootViewController: nextVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
}
