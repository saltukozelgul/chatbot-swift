//
//  APIClient.swift
//  chatbot
//
//  Created by Saltuk Bugra OZELGUL on 5.10.2023.
//

import Foundation
import Alamofire
import DotEnv

class APIClient {
    static let shared = APIClient() // Singleton instance
    
    private let apiKey: String
    private var dataDecoder = JSONDecoder()
    
    // If message has any command in it bot will generate image response
    let imageGenerateCommands = ["draw", "generate image"]
    
    private init() {
        // Load environment variables from .env file
        if let envPath = Bundle.main.path(forResource: ".env", ofType: nil) {
            do {
                try DotEnv.load(path: envPath)
            } catch {
                // Handle errors loading environment variables
                print("Error loading environment variables from .env file: \(error)")
            }
        }
        apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
        print(apiKey)
    }
    
    func generateResponse(prompt: String, maxTokens: Int, temperature: Double, completion: @escaping (Result<ResponseModel, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-instruct",
            "prompt": prompt,
            "max_tokens": maxTokens,
            "temperature": temperature
        ]
        
        AF.request(URLBuilder
            .shared.getResponseUrl()!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate()
        .responseDecodable(of: ResponseModel.self) { response in
            switch response.result {
                case .success(let responseModel):
                    completion(.success(responseModel))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func generateImage(prompt: String, imageCount: Int, size: String, completion: @escaping (Result<ImageResponseModel, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": imageCount,
            "size": size
        ]
        
        AF.request(URLBuilder.shared.getImageResponseUrl()!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: ImageResponseModel.self) { response in
                switch response.result {
                    case .success(let responseModel):
                        completion(.success(responseModel))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
    
}
