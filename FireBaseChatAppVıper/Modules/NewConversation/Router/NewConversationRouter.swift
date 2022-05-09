//
//  NewConversationRouter.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 27.04.2022.
//

import UIKit

class NewConversationRouter: NewConversationPresenterToRouterConformable {
    
    class var shared: NewConversationRouter {
        struct Static {
            static let shared: NewConversationRouter = NewConversationRouter()
        }
        return Static.shared
    }
    
    weak var viewController: NewConversationViewController?
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func dissmisWithCompletion(completion: @escaping () -> Void) {
        viewController?.dismiss(animated: true, completion: completion)
    }
}

// MARK: Module Creation
extension NewConversationRouter {
    
    static func createModule() -> NewConversationViewController {
        
            let router = NewConversationRouter.shared
            let interactor = NewConversationInteractor()
            let presenter = NewConversationPresenter(interactor: interactor, router: router)
            let view = NewConversationViewController.initializeFromStoryboard()
            
            presenter.view = view
            view.presenter = presenter
            interactor.presenter = presenter
            router.viewController = view

        
        return NewConversationRouter.shared.viewController!
    }
}
