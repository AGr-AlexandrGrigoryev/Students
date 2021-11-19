//
//  LoginRepository.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 20.04.2021.
//

import Foundation
import Combine

public struct LoginRepository {
    
    static func fetchAccessToken(userName: String, password: String) -> AnyPublisher<AccountCredentials, Error> {
        // Body
        let body = LoginRequest(userId: userName, password: password, timeToLeave: 300)
        let encodedBody = try? JSONEncoder().encode(body)
        // URLRequest
        var urlRequest = URLRequest(url: Endpoint.login().url)
        // Method
        urlRequest.httpMethod = "POST"
        // Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Body
        urlRequest.httpBody = encodedBody
        // URl Data task
        return URLSession.DataTaskPublisher(request: urlRequest, session: .shared)
            .tryMap{ data, response in
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 403 {
                        throw LoginError.invalidCredentials
                    }
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    
                    throw NetworkServiceError.apiError
                    
                }
                print("httpResponse is: \(httpResponse.statusCode)")
                return data
            }
            .decode(type: AccountCredentials.self, decoder: JSONDecoder())
            .mapError({ (error) -> NetworkServiceError in
                if let error = error as? NetworkServiceError {
                    return error
                }
                return NetworkServiceError.decoding(error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}

extension Endpoint {
    /// Get endpoint for login user
    /// - Returns: endpoint
    static func login() -> Self {
        Endpoint(path: "login")
    }
}
