//
//  RegisterViewController.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit
import SnapKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    var presenter: RegisterViewToPresenterConformable!
    
    private var profilePictureButton: UIButton = {
        let profilePictureButton = UIButton()
        profilePictureButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePictureButton.contentMode = .scaleAspectFit
        profilePictureButton.tintColor = .white
        profilePictureButton.layer.masksToBounds = true
        profilePictureButton.layer.cornerRadius = 120
        return profilePictureButton
    }()
    
    private var firstNameText: UITextField = {
        let firstNameText = UITextField()
        firstNameText.autocapitalizationType = .none
        firstNameText.autocorrectionType = .no
        firstNameText.returnKeyType = .continue
        firstNameText.layer.cornerRadius = 12
        firstNameText.layer.borderWidth = 1
        firstNameText.layer.borderColor = UIColor.lightGray.cgColor
        firstNameText.placeholder = "First Name..."
        firstNameText.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        firstNameText.leftViewMode = .always
        firstNameText.backgroundColor = .white
        return firstNameText
    }()
    
    private var lastNameText: UITextField = {
        let lastNameText = UITextField()
        lastNameText.autocapitalizationType = .none
        lastNameText.autocorrectionType = .no
        lastNameText.returnKeyType = .continue
        lastNameText.layer.cornerRadius = 12
        lastNameText.layer.borderWidth = 1
        lastNameText.layer.borderColor = UIColor.lightGray.cgColor
        lastNameText.placeholder = "Last Name..."
        lastNameText.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        lastNameText.leftViewMode = .always
        lastNameText.backgroundColor = .white
        return lastNameText
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
    
    private var registerButton: UIButton =  {
        let registerButton = UIButton()
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.cornerRadius = 12
        registerButton.layer.masksToBounds = true
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return registerButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapGoBack))
        registerButton.addTarget(self, action: #selector(didTappedRegisterButton), for: .touchUpInside)
        profilePictureButton.addTarget(self, action: #selector(didTappedProfilePic), for: .touchUpInside)
        setupUI()
    }
    
    @objc private func didTappedProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc private func didTappedRegisterButton() {
        guard let firstname = firstNameText.text, let lastName = lastNameText.text, let email = emailText.text, let password = passwordText.text else {
            return
        }
        if firstname.isEmpty {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.firstNameEmpty.rawValue)
        } else if lastName.isEmpty {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.lastNameEmpty.rawValue)
        } else if email.isEmpty {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.emailEmpty.rawValue)
        } else if password.isEmpty {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.passwordEmpty.rawValue)
        } else if password.count < 6 {
            AlertController.notificationAlert(with: self, message: AlertController.Messages.passwordLessThanSix.rawValue)
        } else {
            // FireBase TO-DO
            DatabaseManager.shared.userExists(with: email) { [weak self] operationStatus in
                guard let self = self else { return }
                guard !operationStatus else {
                    // alert user already exists
                    AlertController.notificationAlert(with: self, message: AlertController.Messages.emailAlreadyExists.rawValue)
                    return
                }
                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    guard authResult != nil, error == nil else {
                        print("Error Creating User")
                        return
                    }
                    
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstname,
                                                                        lastNmae: lastName,
                                                                        emailAddress: email))
                    self.presenter.router.openConversations(with: self)
                }
            }
        }
    }
    
    @objc private func didTapGoBack() {
        presenter.goBack()
    }
    
    private func setupUI() {
        view.addSubviews(profilePictureButton, firstNameText, lastNameText, emailText, passwordText, registerButton)
        
        // Constraint with SnapKit
        setupConstraints()
        // Delegates
        firstNameText.delegate = self
        lastNameText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
        
    }
    
    private func setupConstraints() {
        profilePictureButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.height.equalTo(240)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        firstNameText.snp.makeConstraints { make in
            make.top.equalTo(profilePictureButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(54)
        }
        
        lastNameText.snp.makeConstraints { make in
            make.top.equalTo(firstNameText.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(54)
        }
        
        emailText.snp.makeConstraints { make in
            make.top.equalTo(lastNameText.snp.bottom).offset(12)
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
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordText.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(54)
        }
        
    }
}
//MARK: - UITextfield Delegate Methods
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameText {
            lastNameText.becomeFirstResponder()
        } else if textField == lastNameText {
            emailText.becomeFirstResponder()
        } else if  textField == emailText {
            passwordText.becomeFirstResponder()
        } else if textField == passwordText {
            didTappedRegisterButton()
        }
        return true
    }
}
// MARK: - Profile Picture Picker Methods
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        AlertController.profilePictureAlert(with: self) { [weak self] in
            self?.presentLibrary()
        } take: { [weak self] in
            self?.presentCamera()
        }

    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true)
    }
    
    func presentLibrary() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        self.profilePictureButton.setImage(selectedImage, for: .normal)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
// MARK: - Presenter To View Conformable
extension RegisterViewController: RegisterPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension RegisterViewController: Storyboardable {}
