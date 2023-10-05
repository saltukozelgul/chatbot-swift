//
//  UIView+Navigatons.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 6.10.2023.
//

import UIKit

extension UIView {
    
    func navigateToChatDetail(_ chat: Chat) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatViewController.chat = chat
        self.window?.rootViewController?.present(chatViewController, animated: true, completion: nil)
    }
}
