//
//  ChatInteractor.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 26.04.2022.
//

import Foundation

class ChatInteractor: ChatPresenterToInteractorConformable {
    var presenter: ChatInteractorToPresenterConformable?
    var otherUserEmail: String
    var conversationId: String
    var isNewConversation = false
    
    init(email: String? = nil, conversationId: String? = nil) {
        self.otherUserEmail = email ?? ""
        self.conversationId = conversationId ?? ""
    }
    
    func initialize() {
        
    }
    
}
