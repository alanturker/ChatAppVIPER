//
//  ChatRouter.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 26.04.2022.
//

import UIKit

class ChatRouter: ChatPresenterToRouterConformable {
    
    class var shared: ChatRouter {
        struct Static {
            static let shared: ChatRouter = ChatRouter()
        }
        return Static.shared
    }
    
    weak var viewController: ChatViewController?
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: Module Creation
extension ChatRouter {
    
    static func createModule(email: String? = nil, conversationId: String? = nil) -> ChatViewController {
        
            let router = ChatRouter.shared
            let interactor = ChatInteractor(email: email ?? "", conversationId: conversationId ?? "")
            let presenter = ChatPresenter(interactor: interactor, router: router)
            let view = ChatViewController.initializeFromStoryboard()
            
            presenter.view = view
            view.presenter = presenter
            interactor.presenter = presenter
            router.viewController = view

        
        return ChatRouter.shared.viewController!
    }
}
