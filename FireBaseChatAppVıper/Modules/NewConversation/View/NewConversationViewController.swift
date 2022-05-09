//
//  NewConversationViewController.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 27.04.2022.
//

import Foundation
import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    var presenter: NewConversationViewToPresenterConformable!
    
    public var completion: (([String: String]) -> (Void))?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var usersArray = [[String: String]]()
    
    private var resultsArray = [[String: String]]()
    
    private var hasFetched = false
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users.."
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "NewConversationCell")
        return table
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .red
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(noResultsLabel, tableView)
        searchBarConfigure()
        tableViewConfigure()
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dissmissSelf))
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: 0,
                                      y: (view.frame.height - 200) / 2,
                                      width: view.frame.width,
                                      height: 200)
    }
    
    private func searchBarConfigure() {
        searchBar.delegate = self
    }
    
    private func tableViewConfigure() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func dissmissSelf() {
        presenter.router.goBack()
    }
}
// MARK: - SearchBar Delegate Methods
extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resultsArray.removeAll()
            tableView.isHidden = true
            noResultsLabel.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()
        resultsArray.removeAll()
        spinner.show(in: view)
        
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        //check if array has firebase Result
        if hasFetched {
            filterUsers(with: query)
        } else {
            FireBaseDatabaseManager.shared.getAllUsers { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let usersCollection):
                    self.hasFetched = true
                    self.usersArray = usersCollection
                    self.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users \(error)")
                }
            }
        }
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else {
            return
        }
    
        let results: [[String: String]] = self.usersArray.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            
            return name.hasPrefix(term.lowercased())
        })
        
        DispatchQueue.main.async {
            self.spinner.dismiss(animated: true)
        }
        
        self.resultsArray = results
        updateUI()
    }
    
    func updateUI() {
        if resultsArray.isEmpty {
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}
// MARK: - TableView Delegate & DataSource Methods
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewConversationCell", for: indexPath)
        cell.textLabel?.text = resultsArray[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //TODO: start conversation
        let targetUserData = resultsArray[indexPath.row]
        
        presenter.router.dissmisWithCompletion { [weak self] in
            guard let self = self else { return }
            self.completion?(targetUserData)
        }
    }
}
// MARK: - Presenter To View Conformable
extension NewConversationViewController: NewConversationPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension NewConversationViewController: Storyboardable {}
