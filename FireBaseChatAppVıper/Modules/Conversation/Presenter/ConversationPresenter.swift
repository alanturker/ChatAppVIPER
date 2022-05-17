//
//  ConversationPresenter.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import Foundation

class ConversationPresenter: ConversationViewToPresenterConformable {
    weak var view: ConversationPresenterToViewConformable?
    var router: ConversationPresenterToRouterConformable
    var interactor: ConversationPresenterToInteractorConformable
    
    init(interactor: ConversationPresenterToInteractorConformable, router: ConversationPresenterToRouterConformable) {
        self.interactor = interactor
        self.router = router
    }
    
    func initialize() {
        interactor.initialize()
    }
    
    func goBack() {
      
    }
    
    func openLogInPage() {
        router.openLogIn()
    }
    
    func openNewConversationPage() {
        router.openNewConversation()
    }
}

extension ConversationPresenter: ConversationInteractorToPresenterConformable {
    
}
