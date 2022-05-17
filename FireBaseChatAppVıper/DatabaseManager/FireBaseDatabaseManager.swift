//
//  DatabaseManager.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 4.04.2022.
//

import Foundation
import FirebaseDatabase
import MessageKit

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
//MARK: - Get Name From FireBase
extension FireBaseDatabaseManager {
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child(path).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            guard let value = snapshot.value else {
                completion(.failure(FireBaseDataBaseError.failedToFetch))
                return
            }
            completion(.success(value))
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
    public func createNewConversation(otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
              let currentName = UserDefaults.standard.value(forKey: "name") as? String else { return }
        
        let safeEmail = FireBaseDatabaseManager.safeEmail(emailAddress: currentEmail)
        let ref = database.child(safeEmail)
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
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
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            let recipientNewConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": safeEmail,
                "name": currentName,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            //Update conversation for recipient User
            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { [weak self] snapshot in
                if var conversations = snapshot.value as? [[String: Any]] {
                    //append
                    conversations.append(recipientNewConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversations)
                } else {
                    //create
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipientNewConversationData])
                }
            }
            
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
                    self.finishCreatingConversation(conversationID: conversationId, firstMessage: firstMessage, content: message, date: dateString, senderEmail: safeEmail, name: name, completion: completion)
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
                    self.finishCreatingConversation(conversationID: conversationId, firstMessage: firstMessage, content: message, date: dateString, senderEmail: safeEmail, name: name, completion: completion)
                }
            }
        }
    }
    
    private func finishCreatingConversation(conversationID: String, firstMessage: Message, content: Any, date: String, senderEmail: String, name: String, completion: @escaping (Bool) -> Void) {
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
            "name": name,
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
    public func getAllConversations(email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        database.child("\(email)/conversations").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(FireBaseDataBaseError.failedToFetch))
                return
            }
            
            let conversations: [Conversation] = value.compactMap { conversationDictionary in
                guard let conversationId = conversationDictionary["id"] as? String,
                      let name = conversationDictionary["name"] as? String,
                      let otherUserEmail = conversationDictionary["other_user_email"] as? String,
                      let latestMessage = conversationDictionary["latest_message"] as? [String: Any],
                      let sentDate = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                          return nil
                      }
                    
                let latestMessageObject = LatestMessage(date: sentDate,
                                                        message: message,
                                                        isRead: isRead)
                return Conversation(id: conversationId,
                                                      name: name,
                                                      otherUserEmail: otherUserEmail,
                                                      latestMessage: latestMessageObject)
            }
            
            completion(.success(conversations))
        }
    }
    
    ///Fetches all messages with the user passed id
    public func getAllMessagesForConversation(id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        database.child("\(id)/messages").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(FireBaseDataBaseError.failedToFetch))
                return
            }
            
            let messages: [Message] = value.compactMap { messagesDictionary in
                guard let name = messagesDictionary["name"] as? String,
                      let isRead = messagesDictionary["is_read"] as? Bool,
                      let content = messagesDictionary["content"] as? String,
                      let dateString = messagesDictionary["date"] as? String,
                      let date = AppManager.dateFormatter.date(from: dateString),
                      let messageId = messagesDictionary["id"] as? String,
                      let senderEmail = messagesDictionary["sender_email"] as? String,
                      let type = messagesDictionary["type"] as? String else {
                          return nil
                      }
                
                let sender = Sender(senderId: senderEmail,
                                    displayName: name,
                                    photoURL: "")
                
                return Message(sender: sender,
                               messageId: messageId,
                               sentDate: date,
                               kind: .text(content))
            }
            
            completion(.success(messages))
        }
    }
    
    ///Sends message with target conversation and message
    public func sendMessageToFirebase(conversationId: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        // add new message to messages
        // update sender latest message
        // update recipient latest message
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        
        let safeEmail = FireBaseDatabaseManager.safeEmail(emailAddress: myEmail)
        
        database.child("\(conversationId)/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            let messageDate = newMessage.sentDate
            let dateString = AppManager.dateFormatter.string(from: messageDate)
            var message = ""
            switch newMessage.kind {
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
            
            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_email": safeEmail,
                "name": name,
                "is_read": false
            ]
            
            currentMessages.append(newMessageEntry)
            
            self.database.child("\(conversationId)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                self.updateLatestMessage(email: safeEmail, date: dateString, message: message, conversationId: conversationId) { success in
                    if success {
                        self.updateLatestMessage(email: otherUserEmail, date: dateString, message: message, conversationId: conversationId, completion: completion)
                    } else {
                        completion(false)
                    }
                }
                
            }
        }
    }
    
    private func updateLatestMessage(email: String, date: String, message: String, conversationId: String, completion: @escaping (Bool) -> Void) {
        
        self.database.child("\(email)/conversations").observeSingleEvent(of: .value) { snapshot in
            guard var currentUserConversations = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            
            let updatedLatestMessage: [String: Any] = [
                "date": date,
                "is_read": false,
                "message": message
            ]
            
            var targetConversation: [String: Any]?
            
            var position = 0
            
            for conversation in currentUserConversations {
                if let currentId = conversation["id"] as? String, currentId == conversationId {
                    targetConversation = conversation
                    break
                }
                position += 1
            }
            
            targetConversation?["latest_message"] = updatedLatestMessage
            
            guard let targetConversation = targetConversation else {
                completion(false)
                return
            }
            
            currentUserConversations[position] = targetConversation
            self.database.child("\(email)/conversations").setValue(currentUserConversations) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
}
