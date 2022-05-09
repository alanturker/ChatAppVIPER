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
// MARK: - Sending Messages & Conversations
extension FireBaseDatabaseManager {
    /*
     "asdfasdf" {
        "messages" = [
            {
                "id": String
                "type": text, photo, video,
                "content": String,
                "date": Date(),
                "sender_email": String,
                "is_read": true/false
            }
        ]
     }
     
     conversation = [
        "conversation_id": "asdfasdf"
        "other_user_email":
        "latest_message": => {
            "date": Date()
            "latest_message": "message"
            "is_read": true/false
        }
     ]
    
     */
    ///Creates new converastion with other user email and first message sent
    public func createNewConversation(otherUserEmail: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = FireBaseDatabaseManager.safeEmail(emailAddress: currentEmail)
        let ref = database.child(safeEmail)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found.")
                return
            }
            
            let messageDate = firstMessage.sentDate
            let dateString = AppManager.dateFormatter.string(from: messageDate)
            var message = ""
            switch firstMessage.kind {
            case .text(let text):
                message = text
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            }
            let conversationId = "conversation_\(firstMessage.messageId)"
            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                    
                ]
            ]
            
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                // conversations exist for this user
                // append to conversations
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode) { [weak self] error, _ in
                    guard let self = self, error == nil else {
                        completion(false)
                        return
                    }
                    self.finishCreatingConversation(conversationID: conversationId, firstMessage: firstMessage, content: message, date: dateString, senderEmail: safeEmail, completion: completion)
                }
            } else {
                // conversation array doesnt exist
                // create conversations
                userNode["conversations"] = [
                    newConversationData
                ]
                
                ref.setValue(userNode) { [weak self] error, _ in
                    guard let self = self, error == nil else {
                        completion(false)
                        return
                    }
                    self.finishCreatingConversation(conversationID: conversationId, firstMessage: firstMessage, content: message, date: dateString, senderEmail: safeEmail, completion: completion)
                }
            }
        }
    }
    
    private func finishCreatingConversation(conversationID: String, firstMessage: Message, content: Any, date: String, senderEmail: String, completion: @escaping (Bool) -> Void) {
//        "asdfasdf" {
//           "messages" = [
//               {
//                   "id": String
//                   "type": text, photo, video,
//                   "content": String,
//                   "date": Date(),
//                   "sender_email": String,
//                   "is_read": true/false
//               }
//           ]
//        }
        let messages: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": content,
            "date": date,
            "sender_email": senderEmail,
            "is_read": false
        ]
        let value: [String: Any] = [
            "messages": [
                messages
            ]
        ]
        
        database.child(conversationID).setValue(value) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    ///Fetches and returns all conversatins for user with passed email
    public func getAllConversations(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    ///Fetches all messages with the user passed id
    public func getAllMessagesForConversation(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
    
    ///Sends message with target conversation and message
    public func sendMessageToFirebase(conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
}
