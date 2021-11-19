//
//  StudentsRepository.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 30.03.2021.
//

import Foundation
import Combine

enum NetworkServiceError: Error, Equatable {
    case decoding(Error)
    case apiError
    case unauthorizedUser
    
    static func == (lhs: NetworkServiceError, rhs: NetworkServiceError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

enum LoginError: Error, Equatable {
    case invalidCredentials
    
    static func == (lhs: LoginError, rhs: LoginError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

enum StateOfNetworking {
    case error(Error)
    case isLoading
    case unauthorized
    case authorized
    case loaded
    case loggedOut
}



