//
//  ChatAppTabBarRouter.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 5.04.2022.
//

import Foundation
import UIKit

class ChatAppTabBarRouter {
    
    var viewController: UIViewController
    var subModules: SubModules
    
    typealias SubModules = (
    conversations: UINavigationController,
    profilePage: UINavigationController
    )
    
    init(viewController: UIViewController, subModules: SubModules) {
        self.viewController = viewController
        self.subModules = subModules
    }
}

extension ChatAppTabBarRouter {
    static func tabs(with subModules: SubModules) -> ChatAppTabs {
        let conversationsTabBarItem = UITabBarItem(title: K.conversationsTab, image: UIImage(named: K.conversationsTabImage), tag: 11)
        let profileTabBarItem = UITabBarItem(title: K.profileTab, image: UIImage(named: K.profielTabImage), tag: 12)
        
        subModules.conversations.tabBarItem = conversationsTabBarItem
        subModules.profilePage.tabBarItem = profileTabBarItem
      
        return (
            conversations: subModules.conversations,
            profilePage: subModules.profilePage
        )
        
    }
}

