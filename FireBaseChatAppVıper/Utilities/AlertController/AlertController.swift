//
//  AlertController.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 22.03.2022.
//

import Foundation
import UIKit

final class AlertController: NSObject {
    
    class var shared: AlertController {
        struct Static {
            static let shared: AlertController = AlertController()
        }
        return Static.shared
    }
    
    static func emailEmpty(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter an email.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func passwordEmpty(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter a password.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func passwordLessThanSix(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter a password with at least six digits.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func firstNameEmpty(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter your First Name",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func lastNameEmpty(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter your Last Name",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
