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
    
    static func emailEmptyAlert(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter an email.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func passwordEmptyAlert(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter a password.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func passwordLessThanSixAlert(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter a password with at least six digits.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func firstNameEmptyAlert(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter your First Name",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func lastNameEmptyAlert(with vc: UIViewController) {
        let alert = UIAlertController(title: "Woops !",
                                      message: "Please enter your Last Name",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func profilePictureAlert(with vc: UIViewController, choose: @escaping () -> Void, take: @escaping () -> Void) {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to create your profile picture?",
                                            preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let chooseFromLibraryAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
            choose()
        }
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            take()
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(chooseFromLibraryAction)
        actionSheet.addAction(takePhotoAction)
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
}
