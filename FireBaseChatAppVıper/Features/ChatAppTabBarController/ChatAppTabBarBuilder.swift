//
//  ChatAppTabBarBuilder.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 5.04.2022.
//

import UIKit

class ChatAppTabBarBuilder {
    
    static func build(with subModules: ChatAppTabBarRouter.SubModules) -> UITabBarController {
        
        let tabs = ChatAppTabBarRouter.tabs(with: subModules)
        let tabBarController = ChatAppTabBarController(tabs: tabs)
        return tabBarController
    }
}
