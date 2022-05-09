//
//  ConversationProtocol.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit

protocol ConversationViewToPresenterConformable: AnyObject {
    var view: ConversationPresenterToViewConformable? { get set }
    var router: ConversationPresenterToRouterConformable { get set }
    var interactor: ConversationPresenterToInteractorConformable { get set }
    
    func initialize()
    func goBack()
    func openLogInPage()
    func openChatPage()
    func openNewConversationPage()
}

protocol ConversationPresenterToViewConformable: AnyObject {
    
}

protocol ConversationPresenterToInteractorConformable: AnyObject {
    var presenter: ConversationInteractorToPresenterConformable? { get set }
    
    func initialize()
 
}

protocol ConversationInteractorToPresenterConformable: AnyObject {
    
}

protocol ConversationPresenterToRouterConformable: AnyObject {
    func openLogIn()
    func openChat()
    func openNewConversation()
    func createNewChat(result: [String: String])
}
