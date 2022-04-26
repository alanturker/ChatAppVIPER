//
//  LogInPresenter.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 14.03.2022.
//

import Foundation

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
    
    func openRegisterPage() {
        router.openRegister()
    }
}

extension LogInPresenter: LogInInteractorToPresenterConformable {
    
}
