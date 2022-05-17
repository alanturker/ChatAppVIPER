//
//  ChatProtocols.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 26.04.2022.
//

import Foundation

protocol ChatViewToPresenterConformable: AnyObject {
    var view: ChatPresenterToViewConformable? { get set }
    var router: ChatPresenterToRouterConformable { get set }
    var interactor: ChatPresenterToInteractorConformable { get set }
    
    func initialize()
    func goBack()

}

protocol ChatPresenterToViewConformable: AnyObject {
    
}

protocol ChatPresenterToInteractorConformable: AnyObject {
    var presenter: ChatInteractorToPresenterConformable? { get set }
    var otherUserEmail: String { get set }
    var conversationId: String { get set }
    var isNewConversation: Bool { get set }
    
    func initialize()
 
}

protocol ChatInteractorToPresenterConformable: AnyObject {
}

protocol ChatPresenterToRouterConformable: AnyObject {
    func goBack()
}
