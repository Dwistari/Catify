//
//  LoginViewController.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.isEnabled = false
        passwordTF.isSecureTextEntry = true
        loginBtn.setTitleColor(.white, for: .normal)
        
        usernameTF.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
    }


    @IBAction func loginBtn(_ sender: Any) {
        guard let email = usernameTF.text,
              let password = passwordTF.text else { return }
        if CoreDataManager.shared.loginUser(email: email, password: password) != nil {
            showLoginSuccessAndNavigate()
//            SessionManager.shared.login(email: email)
//            startSessionTimer()
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLoginSuccessAndNavigate() {
        let alert = UIAlertController(
            title: "Login Successful", message: nil,
            preferredStyle: .alert
        )
        
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alert.dismiss(animated: true) {
                    self.navigateToHome()
                }
            }
        }
    }

    func navigateToHome() {
        let vc = HomeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldsDidChange() {
        let isUsernameEmpty = usernameTF.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTF.text?.isEmpty ?? true
       isButtonEnable(isEnable: !isUsernameEmpty && !isPasswordEmpty)
    }
    
    private func isButtonEnable(isEnable: Bool) {
        loginBtn.isEnabled = isEnable
        loginBtn.backgroundColor = isEnable ? UIColor.black : UIColor.lightGray
        loginBtn.setTitleColor(isEnable ? .white : .darkGray, for: .normal)
    }
    

}
