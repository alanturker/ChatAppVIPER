//
//  AppContainer.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 16.03.2022.
//

import UIKit

final class AppRouter {
    
    let window: UIWindow
    
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func start() {
        let conversationsVC = ConversationRouter.createModule()
        let nav = UINavigationController(rootViewController: conversationsVC)
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
