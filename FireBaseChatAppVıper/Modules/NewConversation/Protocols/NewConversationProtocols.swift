//
//  NewConversationProtocols.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 27.04.2022.
//

import Foundation

protocol NewConversationViewToPresenterConformable: AnyObject {
    var view: NewConversationPresenterToViewConformable? { get set }
    var router: NewConversationPresenterToRouterConformable { get set }
    var interactor: NewConversationPresenterToInteractorConformable { get set }
    
    func initialize()
    func goBack()

}

protocol NewConversationPresenterToViewConformable: AnyObject {
    
}

protocol NewConversationPresenterToInteractorConformable: AnyObject {
    var presenter: NewConversationInteractorToPresenterConformable? { get set }
    
    func initialize()
}

protocol NewConversationInteractorToPresenterConformable: AnyObject {
}

protocol NewConversationPresenterToRouterConformable: AnyObject {
    func goBack()
}
