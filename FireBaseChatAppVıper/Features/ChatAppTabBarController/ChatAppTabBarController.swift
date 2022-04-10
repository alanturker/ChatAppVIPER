//
//  TabBarController.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 5.04.2022.
//

import UIKit

typealias ChatAppTabs = (
    conversations: UINavigationController,
    profilePage: UINavigationController
)

class ChatAppTabBarController: UITabBarController {
    
    init(tabs: ChatAppTabs) {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [tabs.conversations, tabs.profilePage]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
