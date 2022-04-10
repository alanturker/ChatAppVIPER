//
//  SettingsPresenter.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 5.04.2022.
//

import UIKit

class ProfilePresenter: ProfileViewToPresenterConformable {
    var view: ProfilePresenterToViewConformable?
    var router: ProfilePresenterToRouterConformable
    var interactor: ProfilePresenterToInteractorConformable
    
    init(interactor: ProfilePresenterToInteractorConformable, router: ProfilePresenterToRouterConformable) {
        self.interactor = interactor
        self.router = router
    }
    
    func initialize() {
        interactor.initialize()
    }
    
    func goBack() {
      
    }
    
}

extension ProfilePresenter: ProfileInteractorToPresenterConformable {    
}
