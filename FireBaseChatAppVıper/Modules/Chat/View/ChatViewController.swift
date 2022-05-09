//
//  ChatViewController.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 26.04.2022.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    weak var presenter: ChatViewToPresenterConformable!
    
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil}
        return Sender(senderId: email,
                      displayName: "Ertürk",
                      photoURL: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.backgroundColor = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapGoBack))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    @objc private func didTapGoBack() {
        presenter.goBack()
    }
    
    private func setupCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
}
// MARK: - Input Bar AccessoryView Delegate Methods
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId() else {
                  return
              }
        //Send message
        if presenter.interactor.isNewConversation {
            // create new conversation in database
            let message = Message(sender: selfSender,
                                  messageId: messageId,
                                  sentDate: Date(),
                                  kind: .text(text))
            FireBaseDatabaseManager.shared.createNewConversation(otherUserEmail: presenter.interactor.otherUserEmail, firstMessage: message) { [weak self] success in
                guard self != nil else { return }
                if success {
                    print("message sent successfully")
                } else {
                    print("failed to send message")
                }
            }
        } else {
            // append to existing data
        }
    }
    
    private func createMessageId() -> String? {
        //date, otherUserEmail, senderEmail, random Int
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = FireBaseDatabaseManager.safeEmail(emailAddress: currentUserEmail)
        let dateString = AppManager.dateFormatter.string(from: Date())
        let newIdentifier = "\(presenter.interactor.otherUserEmail)_\(safeEmail)_\(dateString)"
        return newIdentifier
    }
}
// MARK: - Messages CollectionView Delegate & DataSource Methods
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("SelfSender is nil, email should be cached.")
        return Sender(senderId: "12", displayName: "", photoURL: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
// MARK: - Presenter To View Conformable
extension ChatViewController: ChatPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension ChatViewController: Storyboardable {}

