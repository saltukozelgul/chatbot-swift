//
//  ChatMessageCell.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 5.10.2023.
//

import UIKit
import Kingfisher

class ChatMessageCell: UITableViewCell {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!
    @IBOutlet private weak var responseImageView: UIImageView!
    @IBOutlet private weak var iconView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with message: Message) {
        messageLabel.text = message.text
        checkForLoading(message)
        checkForImageOrText(message)
        checkForUserOrBot(message)
    }
    
    func checkForLoading(_ message: Message) {
        if message.text == "Chatbot is typing...." && message.sender == "bot" {
            self.showLoading()
        }
    }
    
    func checkForImageOrText(_ message: Message) {
        if message.imageURL != nil {
            responseImageView.isHidden = false
            messageLabel.isHidden = true
            responseImageView.kf.setImage(with: message.imageURL!)
        } else {
            responseImageView.isHidden = true
            messageLabel.isHidden = false
        }
    }
    
    func checkForUserOrBot(_ message: Message) {
        if message.sender == "user" {
            self.iconView.backgroundColor = .systemBlue
            self.iconImageView.image = UIImage(systemName: "person.fill")
            self.iconImageView.tintColor = .white
        } else {
            self.iconView.backgroundColor = .systemGray6
            self.iconImageView.image = UIImage(systemName: "command.circle")
            self.iconImageView.tintColor = .systemGray
        }
    }
    
    
    
}
