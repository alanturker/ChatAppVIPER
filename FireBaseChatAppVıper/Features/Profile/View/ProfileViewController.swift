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
