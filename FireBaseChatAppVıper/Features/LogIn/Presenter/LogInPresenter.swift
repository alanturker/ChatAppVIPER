//
//  LogInPresenter.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 14.03.2022.
//

import UIKit

class LogInPresenter: LogInViewToPresenterConformable {
    var view: LogInPresenterToViewConformable?
    var router: LogInPresenterToRouterConformable
    var interactor: LogInPresenterToInteractorConformable
    
    init(interactor: LogInPresenterToInteractorConformable, router: LogInPresenterToRouterConformable) {
        self.interactor = interactor
        self.router = router
    }
    
    func initialize() {
        interactor.initialize()
    }
    
    func goBack() {
      
    }
    
    func openRegisterPage(with vc: UIViewController) {
        router.openRegister(with: vc)
    }
}

extension LogInPresenter: LogInInteractorToPresenterConformable {
    
}
