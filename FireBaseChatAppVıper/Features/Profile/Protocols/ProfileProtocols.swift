//
//  ConversationProtocol.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 13.03.2022.
//

import UIKit

protocol ProfileViewToPresenterConformable: AnyObject {
    var view: ProfilePresenterToViewConformable? { get set }
    var router: ProfilePresenterToRouterConformable { get set }
    var interactor: ProfilePresenterToInteractorConformable { get set }
    
    func initialize()
    func goBack()
}

protocol ProfilePresenterToViewConformable: AnyObject {
    
}

protocol ProfilePresenterToInteractorConformable: AnyObject {
    var presenter: ProfileInteractorToPresenterConformable? { get set }
    
    func initialize()
 
}

protocol ProfileInteractorToPresenterConformable: AnyObject {
    
}

protocol ProfilePresenterToRouterConformable: AnyObject {
    func openLogInPage(with vc: UIViewController)
}
