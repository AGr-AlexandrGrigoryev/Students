//
//  Endpoints.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 25.04.2021.
//

import Foundation

struct Endpoint {
    // Path and Query items for converting
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    // Converting an endpoint instance into a URL
    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "emarest.cz.mass-php-1.mit.etn.cz"
        components.path = "/api/v2/" + path
        components.queryItems = queryItems
        
        // Indicates that a precondition was violated.
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        return url
    }
    // Query Items
    static let sort = URLQueryItem(name: "sort", value: "asc")
    static let sleepy = URLQueryItem(name: "sleepy", value: "false")
    // for imitation of error from server, is possible to change "value" on true or false.
    static let badServer = URLQueryItem(name: "badServer", value: "false")
}
