//
//  URLBuilder.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 6.10.2023.
//

import Foundation

class URLBuilder {
    
    static let shared = URLBuilder()
    private var components = URLComponents()
    
    
    private init() {
        self.components.scheme = "https"
        self.components.host = "api.openai.com"
    }
    
    func getResponseUrl() -> URL? {
        self.components.path = "/v1/completions"
        return self.components.url
    }
    
    func getImageResponseUrl() -> URL? {
        self.components.path = "/v1/images/generations"
        return self.components.url
    }
    
}
