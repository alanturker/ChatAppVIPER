//
//  ConversationPresenter.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit

class ConversationPresenter: ConversationViewToPresenterConformable {
    var view: ConversationPresenterToViewConformable?
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
    
    func openLogInPage(with vc: UIViewController) {
        router.openLogIn(with: vc)
    }
}

extension ConversationPresenter: ConversationInteractorToPresenterConformable {
    
}
