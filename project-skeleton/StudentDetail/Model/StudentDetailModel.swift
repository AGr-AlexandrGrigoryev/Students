//
//  BusinessCardViewModel.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 01.04.2021.
//

import Foundation

public struct BusinessCardModelAPIv2: Decodable {
    let name: String
    let participantType: ParticipantType
    let title: String
    let slackURL: URL
    let icon512: URL
    let skills: SkillsV2?
    let homework: [HomeWork]
}
