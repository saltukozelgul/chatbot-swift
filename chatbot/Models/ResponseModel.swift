//
//  ResponseModel.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 6.10.2023.
//

import Foundation

// MARK: - ResponseModel
struct ResponseModel: Codable {
    let id, object: String?
    let created: Int?
    let model: String?
    let choices: [Choice]?
    let usage: Usage?
}

// MARK: - Choice
struct Choice: Codable {
    let text: String?
    let index: Int?
    let logprobs: JSONNull?
    let finishReason: String?
    
    enum CodingKeys: String, CodingKey {
        case text, index, logprobs
        case finishReason = "finish_reason"
    }
}

// MARK: - Usage
struct Usage: Codable {
    let promptTokens, completionTokens, totalTokens: Int?
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
