//
//  ChatMessageCell.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 5.10.2023.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!
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
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.message
        if message.senderType == .bot {
            iconView.backgroundColor = .systemGray6
            iconImageView.image = UIImage(systemName: "person.fill.questionmark")
            iconImageView.tintColor = .systemGray
        }
    }
    
}
