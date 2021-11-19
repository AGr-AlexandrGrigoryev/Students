//
//  Student.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 01.04.2021.

import Foundation

/// Model V1: ParticipantDetail
struct Student: Decodable {
    /// Unique identifier of participant
    var id: String
    /// Name of participant
    var name: String
    /// A type of participant
    var participantType: ParticipantType
    /// Short description of participant
    var title: String
    /// Deep-link to slack application to contact user directly
    var slackURL: URL
    /// Image URL with 512x512 resolution
    var icon512: URL
    /// Image URL with 192x192 resolution
    var icon192: URL
    /// Image URL with 72x72 resolution
    var icon72: URL
    /// Array of skills
    var skills: [Skills]
    /// Array of homeworks
    var homework: [HomeWork]
}

struct Skills: Decodable, Hashable {
    var skillType: String
    var value: Int
}

/// Model v2: ParticipantDetail
struct StudentV2: Decodable {
    /// Unique identifier of participant
    var id: String
    /// Name of participant
    var name: String
    /// A type of participant
    var participantType: ParticipantType
    /// Short description of participant
    var title: String
    /// Deep-link to slack application to contact user directly
    var slackURL: URL
    /// Image URL with 192x192 resolution
    var icon512: URL
    /// Image URL with 192x192 resolution
    var icon192: URL
    /// Image URL with 72x72 resolution
    var icon72: URL
    /// Array of skills (optional!)
    var skills: SkillsV2?
    /// Array of homeworks
    var homework: [HomeWork]
}

struct SkillsV2: Codable, Hashable {
    var swift: Int?
    var ios: Int?
    var android: Int?
    var kotlin: Int?
}



