//
//  UIView.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({addSubview($0)})
    }
}
