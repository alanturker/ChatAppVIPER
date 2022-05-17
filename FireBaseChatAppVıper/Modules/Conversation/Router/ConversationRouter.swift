//
//  ConversationRouter.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit

class ConversationRouter: ConversationPresenterToRouterConformable {
    
    class var shared: ConversationRouter {
        struct Static {
            static let shared: ConversationRouter = ConversationRouter()
        }
        return Static.shared
    }
    
    weak var viewController: ConversationsViewController?
    
    func openLogIn() {
        if let viewController = viewController {
            AppManager.shared.openLogIn(with: viewController)
        }
    }
    
    func openChat(model: Conversation) {
        if let viewController = viewController {
            AppManager.shared.openChat(with: viewController, model: model)
        }
    }
    
    func openNewConversation() {
        if let viewController = viewController {
            AppManager.shared.openNewConversation(with: viewController)
        }
    }
    
    func createNewChat(result: [String: String]) {
        if let viewController = viewController {
            AppManager.shared.openNewChat(with: viewController, result: result)
        }
    }
}

// MARK: Module Creation
extension ConversationRouter {
    
    static func createModule() -> ConversationsViewController {
        
            let router = ConversationRouter.shared
            let interactor = ConversationsInteractor()
            let presenter = ConversationPresenter(interactor: interactor, router: router)
            let view = ConversationsViewController.initializeFromStoryboard()
            
            presenter.view = view
            view.presenter = presenter
            interactor.presenter = presenter
            router.viewController = view

        
        return ConversationRouter.shared.viewController!
    }
}
