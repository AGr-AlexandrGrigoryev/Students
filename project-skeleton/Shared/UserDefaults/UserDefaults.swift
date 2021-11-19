//
//  UserDefaults.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 20.04.2021.
//

import Foundation
import Combine

struct Auth {
    static let userDefaults = UserDefaults.standard
    static let userIdKey = "userId"
    static let passwordKey = "password"
    static let accessTokenKey = "accessToken"
    
}

extension UserDefaults {

    @objc var userId: String? {
        get { string(forKey: Auth.userIdKey) }

        set { set(newValue, forKey: Auth.userIdKey) }
    }
    
    @objc var password: String? {
        get { string(forKey: Auth.passwordKey) }
        
        set { set(newValue, forKey: Auth.passwordKey) }
    }
    
    @objc var accessToken: String? {
        get { string(forKey: Auth.accessTokenKey) }

        set { set(newValue, forKey: Auth.accessTokenKey) }
    }
}
