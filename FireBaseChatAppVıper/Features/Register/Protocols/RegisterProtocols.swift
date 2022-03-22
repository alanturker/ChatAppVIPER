//
//  RegisterProtocols.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 15.03.2022.
//

import UIKit

protocol RegisterViewToPresenterConformable: AnyObject {
    var view: RegisterPresenterToViewConformable? { get set }
    var router: RegisterPresenterToRouterConformable { get set }
    var interactor: RegisterPresenterToInteractorConformable { get set }
    
    func initialize()
    func goBack()

}

protocol RegisterPresenterToViewConformable: AnyObject {
    
}

protocol RegisterPresenterToInteractorConformable: AnyObject {
    var presenter: RegisterInteractorToPresenterConformable? { get set }
    
    func initialize()
 
}

protocol RegisterInteractorToPresenterConformable: AnyObject {
    
}

protocol RegisterPresenterToRouterConformable: AnyObject {
    func goBack()
}
