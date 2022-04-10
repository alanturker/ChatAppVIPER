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
    
    enum Messages: String {
        case emailEmpty = "Please enter an email."
        case passwordEmpty = "Please enter a password."
        case passwordLessThanSix = "Please enter a password with at least six digits."
        case firstNameEmpty = "Please enter your First Name"
        case lastNameEmpty = "Please enter your Last Name"
        case emailAlreadyExists = "Looks like email address already exists."
    }
    
    static func notificationAlert(with vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Woops !",
                                      message: message,
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
    
    static func logOutAlert(with vc: UIViewController, completion: @escaping () -> Void) {
        let actionSheet = UIAlertController(title: "Log Out", message: "Do you really want to log out?", preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            completion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(logOutAction)
        actionSheet.addAction(cancelAction)
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
}
