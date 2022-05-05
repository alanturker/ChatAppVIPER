//
//  ChatAppUser.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 4.04.2022.
//

import Foundation

struct ChatAppUser {
    let firstName: String
    let lastNmae: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
