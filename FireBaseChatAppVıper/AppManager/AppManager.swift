//
//  AppManager.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 14.03.2022.
//

import Foundation
import UIKit

final class AppManager: NSObject {
    
    static let shared: AppManager = AppManager()
    
    func openConversations(with vc: UIViewController) {
        let chatVC = ConversationRouter.createModule()
        let chatNav = UINavigationController(rootViewController: chatVC)
        let profileVC = ProfileRouter.createModule()
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        let subModules = (
            conversations: chatNav,
            profilePage: profileNav
        )
        
        let tabBarController = ChatAppTabBarBuilder.build(with: subModules)
        tabBarController.modalPresentationStyle = .fullScreen
        
        vc.present(tabBarController, animated: true, completion: nil)
    }
    
    func openLogIn(with vc: UIViewController) {
        let logInVC = LogInRouter.createModule()
        let nav = UINavigationController(rootViewController: logInVC)
        nav.modalPresentationStyle = .fullScreen
        
        vc.present(nav, animated: true, completion: nil)
    }
    
    func openRegister(with vc: UIViewController) {
        let registerVC = RegisterRouter.createModule()
        let nav = UINavigationController(rootViewController: registerVC)
        nav.modalPresentationStyle = .fullScreen
        
        vc.present(nav, animated: true, completion: nil)
    }
    
    func openProfile(with vc: UIViewController) {
        let profileVC = ProfileRouter.createModule()
        let nav = UINavigationController(rootViewController: profileVC)
        
        vc.present(nav, animated: true, completion: nil)
    }
    
    func openChat(with vc: UIViewController) {
        let chatVC = ChatRouter.createModule()
        let nav = UINavigationController(rootViewController: chatVC)
        nav.modalPresentationStyle = .fullScreen
        
        vc.present(nav, animated: true, completion: nil)
    }
    
    func openNewConversation(with vc: UIViewController) {
        let newConvVC = NewConversationRouter.createModule()
        let nav = UINavigationController(rootViewController: newConvVC)
        nav.modalPresentationStyle = .formSheet
        
        vc.present(nav, animated: true, completion: nil)
    }
}
