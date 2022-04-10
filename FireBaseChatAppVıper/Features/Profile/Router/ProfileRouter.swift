//
//  SettingsRouter.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 5.04.2022.
//

import UIKit

class ProfileRouter: ProfilePresenterToRouterConformable {
    
    class var shared: ProfileRouter {
        struct Static {
            static let shared: ProfileRouter = ProfileRouter()
        }
        return Static.shared
    }
    
    var viewController: ProfileViewController?
    
    func openLogInPage(with vc: UIViewController) {
        AppManager.shared.openLogIn(with: vc)
    }
}

// MARK: Module Creation
extension ProfileRouter {
    
    static func createModule() -> ProfileViewController {
        
            let router = ProfileRouter.shared
            let interactor = ProfileInteractor()
            let presenter = ProfilePresenter(interactor: interactor, router: router)
            let view = ProfileViewController.initializeFromStoryboard()
            
            presenter.view = view
            view.presenter = presenter
            interactor.presenter = presenter
            router.viewController = view

        
        return ProfileRouter.shared.viewController!
    }
}

