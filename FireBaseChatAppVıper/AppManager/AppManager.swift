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
        
        let conversationsVC = ConversationRouter.createModule()
        let nav = UINavigationController(rootViewController: conversationsVC)
        nav.modalPresentationStyle = .fullScreen
        
        vc.present(nav, animated: false, completion: nil)
    }
    
    func openLogIn(with vc: UIViewController) {
        
        let logInVC = LogInRouter.createModule()
        let nav = UINavigationController(rootViewController: logInVC)
        nav.modalPresentationStyle = .fullScreen
        
        vc.present(nav, animated: false, completion: nil)
    }
    
    func openRegister(with vc: UIViewController) {
        
        let registerVC = RegisterRouter.createModule()
        let nav = UINavigationController(rootViewController: registerVC)
        nav.modalPresentationStyle = .fullScreen
        
        vc.present(nav, animated: true, completion: nil)
    }
}
