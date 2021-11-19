//
//  SkillsModel.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 15.04.2021.
//

import Foundation

public struct SkillsModelArray: Encodable {
    var skillsModel: SkillsV2?
    
    // Create array from json to use for edition skills
    func getSkillsArray() -> [Skill] {
    
        var arrayOfSkills = [Skill]()
        
        if let iosSkill = skillsModel?.ios {
            arrayOfSkills.append(Skill(type: "ios", value: iosSkill))
        }
        if let swiftSkill = skillsModel?.swift {
            arrayOfSkills.append(Skill(type: "swift", value: swiftSkill))
        }
        if let androidSkill = skillsModel?.android {
            arrayOfSkills.append(Skill(type: "android", value: androidSkill))
        }
        if let kotlinSkill = skillsModel?.kotlin {
            arrayOfSkills.append(Skill(type: "kotlin", value: kotlinSkill))
        }
        return arrayOfSkills
    }
}

public struct Skill: Codable {
    var type: String?
    var value: Int?
}
