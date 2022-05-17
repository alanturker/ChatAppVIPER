//
//  ChatViewController.swift
//  FireBaseChatAppVıper
//
//  Created by admin on 13.03.2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    
    weak var presenter: ConversationViewToPresenterConformable!
    
    private var spinner = JGProgressHUD(style: .dark)
    
    private var conversationsArray = [Conversation]()
    
    private var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private var noConversationsLabel: UILabel = {
        var label = UILabel()
        label.text = "No Conversations"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        configureUI()
        setupTableView()
        fetchConversations()
        startListeningForConversations()
        title = "Conversations"
        
        view.backgroundColor = .green
    }
    
    private func startListeningForConversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        let safeEmail = FireBaseDatabaseManager.safeEmail(emailAddress: email)
        FireBaseDatabaseManager.shared.getAllConversations(email: safeEmail) { [weak self] result in
            switch result {
            case .success(let conversations):
                guard !conversations.isEmpty else {
                    return 
                }
                self?.conversationsArray = conversations
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to get all conversation: \(error)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            presenter.openLogInPage()
        } else {
            
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureUI() {
        view.addSubviews(tableView, noConversationsLabel)
    }
    
    private func fetchConversations() {
        tableView.isHidden = false
        //TODO: Realm Container - Reload TableView
    }

}
//MARK: - BarButtonItem Methods
extension ConversationsViewController {
    @objc private func didTapComposeButton() {
        presenter.router.openNewConversation()
    }
}
//MARK: - TableView Delegate & DataSource Methods
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: conversationsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = conversationsArray[indexPath.row]
        
        presenter.router.openChat(model: model)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
// MARK: - Presenter To View Conformable
extension ConversationsViewController: ConversationPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension ConversationsViewController: Storyboardable {}
