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
    
    private let apiUrl = "https://api.openai.com/v1/completions" // Replace with your API base URL
    private var dataDecoder = JSONDecoder()
    
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
    
    
    
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self, decoder: dataDecoder) { (response) in
            guard let data = response.value else {
                completion(.failure(response.error ?? AFError.explicitlyCancelled))
                return
            }
            completion(.success(data))
        }
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
        
        AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
}
