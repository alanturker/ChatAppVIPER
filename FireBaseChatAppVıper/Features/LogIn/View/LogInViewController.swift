//
//  ViewController.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit

class LogInViewController: UIViewController {
    
    var presenter: LogInViewToPresenterConformable!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .purple
        UINavigationBar.appearance().barTintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
    }
    
    @objc private func didTapRegister() {
        presenter.openRegisterPage(with: self)
    }


}

// MARK: - Presenter To View Conformable
extension LogInViewController: LogInPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension LogInViewController: Storyboardable {}
