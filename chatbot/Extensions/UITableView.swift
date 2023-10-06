//
//  UITableView.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 5.10.2023.
//

import UIKit

extension UITableView {
    func scrollToBottom() {
        let indexPath = IndexPath(row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1, section: self.numberOfSections - 1)
        if indexPath.row >= 0 {
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func registerCell<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
}

