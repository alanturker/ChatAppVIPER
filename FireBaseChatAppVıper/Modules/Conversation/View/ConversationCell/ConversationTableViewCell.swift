//
//  ConversationTableViewCell.swift
//  FireBaseChatAppVıper
//
//  Created by alanturker on 10.05.2022.
//

import UIKit
import SnapKit
import SDWebImage

class ConversationTableViewCell: UITableViewCell {
    
    static let identifier = "ConversationTableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(userImageView, userNameLabel, userMessageLabel)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configureCell(with model: Conversation) {
        self.userMessageLabel.text = model.latestMessage.message
        self.userNameLabel.text = model.name
        
        let path = "images/\(model.otherUserEmail)_profile_picture.png"
        
        FireBaseStorageManager.shared.downloadURL(with: path) { [weak self] result in
            switch result {
            case .success(let URL):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: URL, completed: nil)
                }
            case .failure(let error):
                print("failed to get image url: \(error)")
            }
        }
    }
    
    private func configureUI() {
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.left.equalTo(contentView.snp.left).offset(10)
            make.height.width.equalTo(100)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.left.equalTo(userImageView.snp.right).offset(12)
            make.width.equalTo(contentView.snp.width).offset(120)
            make.height.equalTo(40)
        }
        
        userMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.left.equalTo(userImageView.snp.right).offset(12)
            make.width.equalTo(contentView.snp.width).offset(120)
            make.height.equalTo(50)
        }
    }

}
