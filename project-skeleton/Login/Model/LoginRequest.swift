//
//  LoginRequest.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 11.04.2021.
//

import Foundation

/// Model v2: LoginRequest
struct LoginRequest: Encodable {
    
    // User identifier (required)
    let userId: String
    // User password (required)
    let password: String
    // value from range [30-3600] number of seconds returned token is valid (optional)
    // default = 10 min.
    let timeToLeave: Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case password
        case timeToLeave = "time-to-live"
    }
}
