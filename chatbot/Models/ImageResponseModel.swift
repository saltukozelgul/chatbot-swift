//
//  ImageResponseModel.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 7.10.2023.
//

import Foundation

// MARK: - ImageResponseModel
struct ImageResponseModel: Codable {
    let created: Int?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let url: String?
}
