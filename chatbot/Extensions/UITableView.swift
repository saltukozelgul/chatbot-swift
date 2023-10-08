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
    
    // If there is no item in tableView notify user with custom view
    func setEmptyView(title: String, message: String, isCustomList: Bool = false) {
        let emptyView = EmptyViewForTableView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        emptyView.configure(title: title, message: message, isCustomList: isCustomList)
        self.backgroundView = emptyView
    }
    
    func restoreBackground() {
        self.backgroundView = nil
    }
    
}

