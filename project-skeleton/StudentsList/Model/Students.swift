//
//  Students.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 30.03.2021.
//

import Foundation

struct Students: Decodable {
    /// Unique identifier of participant
    let id: String
    /// Name of participant
    var name: String
    /// A type of participant
    var participantType: ParticipantType
    /// Short description of participant
    var title: String
    /// Image URL with 512x512 resolution
    var icon512: URL
    /// Image URL with 192x192 resolution
    var icon192: URL
    /// Image URL with 72x72 resolution
    var icon72: URL
    //Array of home-works
    var homework: [HomeWork]
}

enum ParticipantType: String, Decodable {
    case all
    case iosStudent
    case androidStudent
}

struct HomeWork: Decodable, Hashable {
    /// State of homework
    var state: State
    /// Number of homework
    var number: Int
    /// Id
    var id: Int
}

/// HomeworkTypeString/Enum
enum State: String, Decodable {
    case acceptance
    case review
    case push
    case comingsoon
    case ready
    
}
