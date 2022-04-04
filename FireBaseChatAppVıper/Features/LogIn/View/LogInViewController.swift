//
//  ViewController.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit
import SnapKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    var presenter: LogInViewToPresenterConformable!
    
    private var chatAppImage: UIImageView = {
        let chatImage = UIImageView()
        chatImage.image = UIImage(named: "chatApp")
        chatImage.contentMode = .scaleAspectFit
        return chatImage
    }()
    
    private var emailText: UITextField = {
        let emailText = UITextField()
        emailText.autocapitalizationType = .none
        emailText.autocorrectionType = .no
        emailText.returnKeyType = .continue
        emailText.layer.cornerRadius = 12
        emailText.layer.borderWidth = 1
        emailText.layer.borderColor = UIColor.lightGray.cgColor
        emailText.placeholder = "Email Adress..."
        emailText.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailText.leftViewMode = .always
        emailText.backgroundColor = .white
        return emailText
    }()
    
    private var passwordText: UITextField = {
        let passwordText = UITextField()
        passwordText.autocapitalizationType = .none
        passwordText.autocorrectionType = .no
        passwordText.returnKeyType = .done
        passwordText.layer.cornerRadius = 12
        passwordText.layer.borderWidth = 1
        passwordText.layer.borderColor = UIColor.lightGray.cgColor
        passwordText.placeholder = "Password..."
        passwordText.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passwordText.leftViewMode = .always
        passwordText.backgroundColor = .white
        passwordText.isSecureTextEntry = true
        return passwordText
    }()
    
    private var loginButton: UIButton =  {
        let loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return loginButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .secondarySystemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        loginButton.addTarget(self, action: #selector(didTappedLogInButton), for: .touchUpInside)
        setupUI()
    }
    
    @objc private func didTappedLogInButton() {
        guard let email = emailText.text, let password = passwordText.text else { return }
        
        if email.isEmpty {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.emailEmpty.rawValue)
        } else if password.isEmpty {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.passwordEmpty.rawValue)
        } else if password.count < 6 {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.passwordLessThanSix.rawValue)
        } else {
            // FireBase Code TO-DO
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                guard authResult != nil, error == nil else {
                    print("Failed to LogIn user with email: \(email)")
                    return
                }
                
//                let user = result.user
//                print("Logged In User: \(user)")
                
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @objc private func didTapRegister() {
        presenter.openRegisterPage(with: self)
    }
    
    private func setupUI() {
        view.addSubviews(chatAppImage, emailText, passwordText, loginButton)
        
        // Constraint with SnapKit
        setupConstraints()
        // Delegates
        emailText.delegate = self
        passwordText.delegate = self
        
    }
    
    private func setupConstraints() {
        chatAppImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.height.equalTo(250)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        emailText.snp.makeConstraints { make in
            make.top.equalTo(chatAppImage.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(54)
        }
        
        passwordText.snp.makeConstraints { make in
            make.top.equalTo(emailText.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(54)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordText.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(54)
        }
        
    }


}
//MARK: - UITextfield Delegate Methods
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailText {
            passwordText.becomeFirstResponder()
        } else if textField == passwordText {
            didTappedLogInButton()
        }
        return true
    }
}
// MARK: - Presenter To View Conformable
extension LogInViewController: LogInPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension LogInViewController: Storyboardable {}
