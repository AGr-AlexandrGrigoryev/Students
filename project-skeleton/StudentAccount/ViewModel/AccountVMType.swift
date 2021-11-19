//
//  AccountVMType.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 21.04.2021.
//

import Foundation
import Combine

protocol AccountVMType {
    
    var statePublisher: PassthroughSubject<StateOfNetworking, Never> { get }
    var loggedUser: PassthroughSubject <StudentV2, Never> { get }
    var userSkills: PassthroughSubject <SkillsModelArray, Never> { get }
    var skillSubject: PassthroughSubject<Skill, Never> { get }
    
    func loadLoggedUser(by id: String)
    func setSkillsForUser(by id: String, skillArray: [Skill])
}
