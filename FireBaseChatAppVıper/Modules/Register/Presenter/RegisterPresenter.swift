//
//  RegisterPresenter.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 15.03.2022.
//

import Foundation

class RegisterPresenter: RegisterViewToPresenterConformable {
    weak var view: RegisterPresenterToViewConformable?
    var router: RegisterPresenterToRouterConformable
    var interactor: RegisterPresenterToInteractorConformable
    
    init(interactor: RegisterPresenterToInteractorConformable, router: RegisterPresenterToRouterConformable) {
        self.interactor = interactor
        self.router = router
    }
    
    func initialize() {
        interactor.initialize()
    }
    
    func goBack() {
        router.goBack()
    }
}

extension RegisterPresenter: RegisterInteractorToPresenterConformable {
    
}
