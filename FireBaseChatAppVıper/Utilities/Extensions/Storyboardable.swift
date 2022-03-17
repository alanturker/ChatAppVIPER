//
//  Storyboardable.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 15.03.2022.
//

import UIKit

// MARK: - Storyboardable
protocol Storyboardable where Self: UIViewController {

    static var identifiers: (storyboardName: String, viewControllerIdentifier: String) { get }
    static func initializeFromStoryboard() -> Self
}

extension Storyboardable {

    static var identifiers: (storyboardName: String, viewControllerIdentifier: String) {
        let identifier: String = String(describing: self)
        let storyboard: String = identifier.replacingOccurrences(of: "ViewController", with: "")
        return (storyboard, identifier)
    }

    static func initializeFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: identifiers.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifiers.viewControllerIdentifier) as! Self
        return viewController
    }
}
