//
//  ViewController.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit

class LogInViewController: UIViewController {
    
    var presenter: LogInViewToPresenterConformable!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
    }


}

// MARK: - Presenter To View Conformable
extension LogInViewController: LogInPresenterToViewConformable {
    
}
