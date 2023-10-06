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
        if message.imageURL != nil {
            responseImageView.isHidden = false
            messageLabel.isHidden = true
            responseImageView.kf.setImage(with: message.imageURL!)
        } else {
            responseImageView.isHidden = true
            messageLabel.isHidden = false
        }
        if message.sender != "user" {
            self.iconView.backgroundColor = .systemGray6
            self.iconImageView.image = UIImage(systemName: "person.fill.questionmark")
            self.iconImageView.tintColor = .systemGray
        } else {
            self.iconView.backgroundColor = .systemBlue
            self.iconImageView.image = UIImage(systemName: "person.fill")
            self.iconImageView.tintColor = .white
        }
    }
    
}
