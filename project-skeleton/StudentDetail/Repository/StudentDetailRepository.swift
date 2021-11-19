//
//  StudentDetailRepository.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 20.04.2021.
//

import Foundation
import Combine

private var bag = Set<AnyCancellable>()

public struct StudentDetailRepository {
    
    static func fetchStudent(by id: String) -> AnyPublisher<BusinessCardModelAPIv2, Error> {
        var request = URLRequest(url: Endpoint.participants(with: id).url)
        
        request.addValue(Auth.userDefaults.accessToken ?? "", forHTTPHeaderField: "access_token")
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            //response and error
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
            .decode(type: BusinessCardModelAPIv2.self, decoder: JSONDecoder()) 
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
