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
    
    private let spinner = JGProgressHUD(style: .dark)
    
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
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarConfigure()
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dissmissSelf))
        searchBar.becomeFirstResponder()
    }
    
    private func searchBarConfigure() {
        searchBar.delegate = self
    }
    
    @objc private func dissmissSelf() {
        presenter.router.goBack()
    }
}
// MARK: - SearchBar Delegate Methods
extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}
// MARK: - Presenter To View Conformable
extension NewConversationViewController: NewConversationPresenterToViewConformable {}
// MARK: - Presenter To View Conformable
extension NewConversationViewController: Storyboardable {}
