//
//  UIColor.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import Foundation
import UIKit

extension UIColor {
    static func colorFromRGB(r: Int, g: Int, b: Int, a: Double = 1) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a))
    }
}
