//
//  ChatPresenter.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 26.04.2022.
//

import Foundation

class ChatPresenter: ChatViewToPresenterConformable {
    weak var view: ChatPresenterToViewConformable?
    var router: ChatPresenterToRouterConformable
    var interactor: ChatPresenterToInteractorConformable
    
    init(interactor: ChatPresenterToInteractorConformable, router: ChatPresenterToRouterConformable) {
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

extension ChatPresenter: ChatInteractorToPresenterConformable {
}
