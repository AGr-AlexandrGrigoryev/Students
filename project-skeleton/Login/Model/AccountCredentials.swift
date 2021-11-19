//
//  AccountCredentials.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 11.04.2021.
//

import Foundation

/// Model v2:  LoginResponse
struct AccountCredentials: Decodable {
    // Server time of token expiration
    let expiration: String
    // Token
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case expiration = "$expiration"
        case accessToken = "access_token"
    }
}
