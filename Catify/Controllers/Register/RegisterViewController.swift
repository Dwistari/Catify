//
//  RegisterViewController.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBtn.isEnabled = false
        registerBtn.setTitleColor(.white, for: .normal)
        passwordTF.isSecureTextEntry = true

        nameTF.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        usernameTF.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        registerUser()
    }
    
    
    @IBAction func loginBtn(_ sender: Any) {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func registerUser() {
        guard let name = nameTF.text, let email = usernameTF.text,
              let password = passwordTF.text else {  return  }
        
        let success = CoreDataManager.shared.registerUser(name: name, username: email, password: password)
        if success {
            let alert = UIAlertController(title: "Success", message: "Registration successful!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                let vc = LoginViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            present(alert, animated: true)
        } else {
            showAlert(message: "Username already exists.", title: "Failed")
        }
    }
    
    private func showAlert(message: String, title: String = "Alert") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func isButtonEnable(isEnable: Bool) {
        registerBtn.isEnabled = isEnable
        registerBtn.backgroundColor = isEnable ? UIColor.black : UIColor.lightGray
        registerBtn.setTitleColor(isEnable ? .white : .darkGray, for: .normal)
    }
    
    @objc func textFieldsDidChange() {
        let isNameEmpty = nameTF.text?.isEmpty ?? true
        let isUsernameEmpty = usernameTF.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTF.text?.isEmpty ?? true
       isButtonEnable(isEnable: !isNameEmpty && !isUsernameEmpty && !isPasswordEmpty)
    }
    
}
