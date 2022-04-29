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
    
    private var tableView: UITableView = {
        var tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ConversationCell")
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
        title = "Conversations"
        
        view.backgroundColor = .green
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.router.openChat()
    }
    
}
// MARK: - Presenter To View Conformable
extension ConversationsViewController: ConversationPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension ConversationsViewController: Storyboardable {}
