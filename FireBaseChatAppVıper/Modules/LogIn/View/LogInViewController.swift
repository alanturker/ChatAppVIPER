//
//  ViewController.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit
import SnapKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import JGProgressHUD
import SwiftUI

class LogInViewController: UIViewController {
    
    var presenter: LogInViewToPresenterConformable!
    
    private var spinner = JGProgressHUD(style: .dark)
    
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
    
    private let faceBookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email","public_profile"]
        return button
    }()
    
    private let googleLoginButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .secondarySystemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        loginButton.addTarget(self, action: #selector(didTappedLoginButton), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(didTappedGoogleLoginButton), for: .touchUpInside)
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        dismissKeyboard()
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.view.frame.origin.y = 0 - (keyboardSize.height/2)
    }
    
    @objc private func didTappedLoginButton() {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        guard let email = emailText.text, let password = passwordText.text else { return }
        
        if email.isEmpty {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.emailEmpty.rawValue)
        } else if password.isEmpty {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.passwordEmpty.rawValue)
        } else if password.count < 6 {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.passwordLessThanSix.rawValue)
        } else {
            spinner.show(in: view)
            // FireBase Code TO-DO
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                
                guard let result = authResult, error == nil else {
                    print("Failed to LogIn user with email: \(email)")
                    return
                }
                
                let user = result.user
                
                UserDefaults.standard.set(email, forKey: "email")
                print("Logged In User: \(user)")
                
                DispatchQueue.main.async {
                    self.spinner.dismiss(animated: true)
                }
                
                self.presenter.router.openConversations()
            }
        }
        
    }
    
    @objc private func didTapRegister() {
        presenter.router.openRegister()
    }
    
    private func setupUI() {
        view.addSubviews(chatAppImage, emailText, passwordText, loginButton, faceBookLoginButton, googleLoginButton)
        
        // Constraint with SnapKit
        setupConstraints()
        // Delegates
        emailText.delegate = self
        passwordText.delegate = self
        faceBookLoginButton.delegate = self
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
        
        faceBookLoginButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(54)
        }
        
        googleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(faceBookLoginButton.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
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
            didTappedLoginButton()
        }
        return true
    }
    
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}
//MARK: - Google Login Methods
extension LogInViewController {
    @objc private func didTappedGoogleLoginButton() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            guard user != nil, error == nil else {
                print("Failed to sign in with Google")
                return
            }
            
            spinner.show(in: view)
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken,
                  let email = user?.profile?.email,
                  let firstName = user?.profile?.givenName,
                  let lastName = user?.profile?.familyName else { return }
            
            UserDefaults.standard.set(email, forKey: "email")
            
            FireBaseDatabaseManager.shared.userExists(with: email) { operationStatus in
                if !operationStatus {
                    let chatUser = ChatAppUser(firstName: firstName, lastNmae: lastName, emailAddress: email)
                    FireBaseDatabaseManager.shared.insertUser(with: chatUser) { success in
                        if success {
                            // upload image
                            if ((user?.profile?.hasImage) != nil) {
                                guard let url = user?.profile?.imageURL(withDimension: 200) else  {
                                    return
                                }
                                
                                URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                    guard let data = data else {
                                        return
                                    }
                                    
                                    let fileName = chatUser.profilePictureFileName
                                    
                                    FireBaseStorageManager.shared.uploadPicture(with: data, fileName: fileName, completion: { result in
                                        switch result {
                                        case .success(let downloadURL):
                                            UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                                            print(downloadURL)
                                        case .failure(let error):
                                            print("StorageManager error: \(error)")
                                        }
                                    })
                                }).resume()
                            }
                            
                        }
                    }
                }
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let self = self else { return }
                guard authResult != nil, error == nil else {
                    print("Failed to signIn with Google credential to Firebase")
                    return
                }
                
                DispatchQueue.main.async {
                    self.spinner.dismiss(animated: true)
                }
                
                self.presenter.router.openConversations()
                print("Successfully logged in with Google credential to Firebase")
            }
        }
    }
}
//MARK: - Facebook Login Delegate Methods
extension LogInViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no-operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("Failed to login Facebook")
            return
        }
        
        spinner.show(in: view)
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, picture.type(large)"], tokenString: token, version: nil, httpMethod: .get)
        
        facebookRequest.start { _, result, error in
            guard let result = result as? [String: Any], error == nil else {
                print("Failed to start Facebook graphRequest")
                return
            }
            
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any],
                  let data = picture["data"] as? [String: Any],
                  let pictureURL = data["url"] as? String else {
                      print("Failed to get Name & Email from Facebook Result")
                      return
                  }
            
            UserDefaults.standard.set(email, forKey: "email")
            
            //            let nameComponents = userName.components(separatedBy: " ")
            //
            //            guard nameComponents.count == 2 else { return }
            //
            //            let firstName = nameComponents[0]
            //            let lastName = nameComponents[1]
            
            FireBaseDatabaseManager.shared.userExists(with: email) { operationStatus in
                if !operationStatus {
                    let chatUser = ChatAppUser(firstName: firstName, lastNmae: lastName, emailAddress: email)
                    FireBaseDatabaseManager.shared.insertUser(with: chatUser) { success in
                        if success {
                            // upload image
                            guard let url = URL(string: pictureURL) else { return }
                            print("Downloading data from Facebook image")
                            
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                guard let data = data else {
                                    print("Failed to get data from Facebook.")
                                    return
                                }
                                print("Got data from FaceBook, uploading...")
                                
                                let fileName = chatUser.profilePictureFileName
                                
                                FireBaseStorageManager.shared.uploadPicture(with: data, fileName: fileName, completion: { result in
                                    switch result {
                                    case .success(let downloadURL):
                                        UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                                        print(downloadURL)
                                    case .failure(let error):
                                        print("StorageManager error: \(error)")
                                    }
                                })
                            }.resume()
                        }
                    }
                }
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let self = self else { return }
                guard authResult != nil, error == nil else {
                    print("Failed to signIn with Facebook credential to Firebase")
                    return
                }
                
                DispatchQueue.main.async {
                    self.spinner.dismiss(animated: true)
                }
                self.presenter.router.openConversations()
                print("Successfully logged in with Facebook credential to Firebase")
            }
        }
    }
}
// MARK: - Presenter To View Conformable
extension LogInViewController: LogInPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension LogInViewController: Storyboardable {}

