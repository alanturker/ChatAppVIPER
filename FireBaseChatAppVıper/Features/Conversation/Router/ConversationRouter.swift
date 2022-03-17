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
    
    var viewController: ConversationsViewController?
    
    func openLogIn(with vc: UIViewController) {
        AppManager.shared.openLogIn(with: vc)
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
