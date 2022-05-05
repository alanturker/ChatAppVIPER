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
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
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
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastNmae
        ]) { error, _ in
            guard error == nil else {
                print("Failed to insert newUser.")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // append to user dictionary
                    let newElement =  [
                        "name": user.firstName + " " + user.lastNmae,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    
                    self.database.child("users").setValue(usersCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                } else {
                    // create that array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastNmae,
                            "email": user.safeEmail
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                }
            })
            
        }
    }
}
//MARK: - Database Functions
extension FireBaseDatabaseManager {
    public typealias getAllUsersCompletion = (Result<[[String: String]], Error>) -> Void
    
    public func getAllUsers(completion: @escaping getAllUsersCompletion) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(FireBaseDataBaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    
    public enum FireBaseDataBaseError: Error {
        case failedToFetch
    }
}
