//
//  SettingsViewController.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 5.04.2022.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: ProfileViewToPresenterConformable!
    
    let data = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = createTableViewHeader()
    }
    
    private func createTableViewHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = FireBaseDatabaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/" + fileName
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.view.frame.width,
                                              height: 300))
        headerView.backgroundColor = .lightGray
        
        let imageView = UIImageView(frame: CGRect(x: ((Int(headerView.frame.width) - 150) / 2),
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        headerView.addSubview(imageView)
        
        FireBaseStorageManager.shared.downloadURL(with: path) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let url):
                self.dowloadImage(imageView: imageView, url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
                
            }
        }
        return headerView
    }
    
    private func dowloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard self != nil else { return }
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }.resume()
    }

}
// MARK: - TableView Delegate & Datasource Methods
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.profileCell, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AlertController.logOutAlert(with: self) { [weak self] in
            guard let self = self else { return }
            //Facebook Log Out
            FBSDKLoginKit.LoginManager().logOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                self.presenter.router.openLogInPage(with: self)
            } catch {
                print("Failed to LogOut")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - Presenter To View Conformable
extension ProfileViewController: ProfilePresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension ProfileViewController: Storyboardable {}
