//
//  ChatViewController.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit

class ConversationsViewController: UIViewController {
    
    var presenter: ConversationViewToPresenterConformable!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "LoggedIn")
        
        if !isLoggedIn {
            
            AppManager.shared.openLogIn(with: self)
            
        }
    }

}

// MARK: - Presenter To View Conformable
extension ConversationsViewController: ConversationPresenterToViewConformable {
    
}
