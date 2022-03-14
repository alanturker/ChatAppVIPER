//
//  LogInProtocols.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 14.03.2022.
//

import Foundation

protocol LogInViewToPresenterConformable: AnyObject {
    var view: LogInPresenterToViewConformable? { get set }
    var router: LogInPresenterToRouterConformable { get set }
    var interactor: LogInPresenterToInteractorConformable { get set }
    
    func initialize()
    func goBack()

}

protocol LogInPresenterToViewConformable: AnyObject {
    
}

protocol LogInPresenterToInteractorConformable: AnyObject {
    var presenter: LogInInteractorToPresenterConformable? { get set }
    
    func initialize()
 
}

protocol LogInInteractorToPresenterConformable: AnyObject {
    
}

protocol LogInPresenterToRouterConformable: AnyObject {
   
}
