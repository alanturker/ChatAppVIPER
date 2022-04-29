//
//  RegisterRouter.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 15.03.2022.
//

import UIKit

class RegisterRouter: RegisterPresenterToRouterConformable {
    
    class var shared: RegisterRouter {
        struct Static {
            static let shared: RegisterRouter = RegisterRouter()
        }
        return Static.shared
    }
    
    weak var viewController: RegisterViewController?
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func openConversations(with vc: UIViewController){
        AppManager.shared.openConversations(with: vc)
    }
}

extension RegisterRouter {
    
    static func createModule() -> RegisterViewController {
        
        let router = RegisterRouter.shared
        let interactor = RegisterInteractor()
        let presenter = RegisterPresenter(interactor: interactor, router: router)
        let view = RegisterViewController.initializeFromStoryboard()
        
        presenter.view = view
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return RegisterRouter.shared.viewController!
    }
}
