//
//  RegisterViewController.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var presenter: RegisterViewToPresenterConformable!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
    }
    


}
// MARK: - Presenter To View Conformable
extension RegisterViewController: RegisterPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension RegisterViewController: Storyboardable {}
