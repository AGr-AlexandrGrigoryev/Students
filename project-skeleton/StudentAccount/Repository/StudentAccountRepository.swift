//
//  StudentAccountRepository.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 20.04.2021.
//

import Foundation
import Combine

private var bag = Set<AnyCancellable>()

public struct StudentAccountRepository {
    
    static func fetchLoggedStudent(by id: String) -> AnyPublisher<StudentV2, Error>{ 
        var request = URLRequest(url: Endpoint.participants(with: id).url)
        request.addValue(Auth.userDefaults.accessToken ?? "", forHTTPHeaderField: "access_token")
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .print("#### ")
            .tryMap { data, response in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 401 {
                        throw NetworkServiceError.unauthorizedUser
                    }
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkServiceError.apiError
                }
                print("httpResponse is: \(httpResponse.statusCode)")
                return data
            }
            .decode(type: StudentV2.self, decoder: JSONDecoder())
            .mapError({ (error) -> NetworkServiceError in
                if let error = error as? NetworkServiceError {
                    return error
                }
                return NetworkServiceError.decoding(error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    

    static func setSkills(by id: String, skills: SkillsV2) -> AnyPublisher<SkillsV2, Error> {
        // Body
        let body = skills
        let encodedBody = try? JSONEncoder().encode(body)
        // URLRequest
        var urlRequest = URLRequest(url: Endpoint.participantsSkills(with: id).url)
        // Method
        urlRequest.httpMethod = "POST"
        // Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(Auth.userDefaults.accessToken ?? "", forHTTPHeaderField: "access_token")
        // Body
        urlRequest.httpBody = encodedBody
        return URLSession.DataTaskPublisher(request: urlRequest, session: .shared)
            .tryMap{ data, response in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 401 {
                        throw NetworkServiceError.unauthorizedUser
                    }
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkServiceError.apiError
                }
                print("httpResponse is: \(httpResponse.statusCode)")
                return data
            }
            .decode(type: SkillsV2.self, decoder: JSONDecoder())
            .mapError({ (error) -> NetworkServiceError in
                if let error = error as? NetworkServiceError {
                    return error
                }
                return NetworkServiceError.decoding(error)
            })
            .print("#### skills:")
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
extension Endpoint {
    /// Get endpoint for identifier  participant
    /// - Parameter id: id of participant
    /// - Returns: endpoint
    static func participants(with id: String) -> Self {
        Endpoint(path: "participants/\(id)",
                 queryItems: [badServer, sleepy] )
    }
    
    /// Get endpoint for participant skills
    /// - Parameter id: id of participant
    /// - Returns: endpoint
    static func participantsSkills(with id: String) -> Self {
        Endpoint(path: "participants/\(id)/skills",
                 queryItems: [badServer, sleepy] )
    }
}


