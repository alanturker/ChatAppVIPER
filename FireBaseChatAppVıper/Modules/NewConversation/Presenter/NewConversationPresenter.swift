//
//  NewConversationPresenter.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 27.04.2022.
//

import Foundation

class NewConversationPresenter: NewConversationViewToPresenterConformable {
    weak var view: NewConversationPresenterToViewConformable?
    var router: NewConversationPresenterToRouterConformable
    var interactor: NewConversationPresenterToInteractorConformable
    
    init(interactor: NewConversationPresenterToInteractorConformable, router: NewConversationPresenterToRouterConformable) {
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

extension NewConversationPresenter: NewConversationInteractorToPresenterConformable {
}
