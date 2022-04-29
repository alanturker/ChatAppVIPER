//
//  ChatViewController.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 26.04.2022.
//

import Foundation
import UIKit
import MessageKit

class ChatViewController: MessagesViewController {
    
    weak var presenter: ChatViewToPresenterConformable!
    
    private var messages = [Message]()
    
    private var selfSender = Sender(senderId: "1",
                                    displayName: "Ertürk",
                                    photo: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        title = "Ertürk"
        view.backgroundColor = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapGoBack))
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello how are you")))
    }
    
    @objc private func didTapGoBack() {
        presenter.goBack()
    }
    
    private func setupCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}
//MARK: - Messages CollectionView Delegate & DataSource Methods
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
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

