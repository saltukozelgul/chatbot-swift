//
//  UIView.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 8.10.2023.
//

import UIKit

extension UIView {
    func showLoading() {
        let loadingView = LoadingView(frame: frame)
        self.addSubview(loadingView)
    }
    
    func hideLoading() {
        if let loadingView = self.subviews.first(where: { $0 is LoadingView }) {
            loadingView.removeFromSuperview()
        }
    }
    
    func setCornerRadius(_ value: CGFloat) {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }
    
}
