//
//  DatabaseManager.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 4.04.2022.
//

import Foundation
import FirebaseDatabase

final class FireBaseDatabaseManager {
    
    static let shared: FireBaseDatabaseManager = FireBaseDatabaseManager()
    
    private let database = Database.database().reference()
    
  
    
}

//MARK: - Account Management
extension FireBaseDatabaseManager {
    public func userExists(with email: String, completion: @escaping (_ operationStatus: Bool) -> Void) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard self != nil else { return }
            guard (snapshot.value as? String) != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// Inserts new User to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastNmae
        ])
    }
}
