//
//  LogInRouter.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 14.03.2022.
//

import UIKit

class LogInRouter: LogInPresenterToRouterConformable {
    
    class var shared: LogInRouter {
        struct Static {
            static let shared: LogInRouter = LogInRouter()
        }
        return Static.shared
    }
    
    var viewController: LogInViewController?
    
    func openRegister() {
        if let viewController = viewController {
            AppManager.shared.openRegister(with: viewController)
        }
    }
    
    func openConversations() {
        if let viewController = viewController {
            AppManager.shared.openConversations(with: viewController)
        }
    }
}

// MARK: Module Creation
extension LogInRouter {
    
    static func createModule() -> LogInViewController {
        
            let router = LogInRouter.shared
            let interactor = LogInInteractor()
            let presenter = LogInPresenter(interactor: interactor, router: router)
            let view = LogInViewController.initializeFromStoryboard()
            
            presenter.view = view
            view.presenter = presenter
            interactor.presenter = presenter
            router.viewController = view

        
        return LogInRouter.shared.viewController!
    }
}
