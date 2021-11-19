//
//  AccountVM.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 13.04.2021.
//

import Foundation
import Combine

class AccountVM: AccountVMType {
    
    var statePublisher = PassthroughSubject<StateOfNetworking, Never> ()
    let loggedUser = PassthroughSubject <StudentV2, Never>() 
    let userSkills = PassthroughSubject <SkillsModelArray, Never>()
    public let skillSubject = PassthroughSubject<Skill, Never>()
    private var bag = Set<AnyCancellable>()
    
    func loadLoggedUser(by id: String) {
        statePublisher.send(StateOfNetworking.isLoading)
        print("log loading")
        StudentAccountRepository.fetchLoggedStudent(by: id)
            .print("Logged user: ")
            .sink { [weak self] (completion)  in
                
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                    if err as! NetworkServiceError == .apiError {
                        self?.statePublisher.send(StateOfNetworking.error(err))
                        print("### Retrieving data failed with error \(err)")
                    } else if err as! NetworkServiceError == .unauthorizedUser {
                        //if  user is unauthorized
                        self?.statePublisher.send(StateOfNetworking.unauthorized)
                        print("### Retrieving data failed with error \(err)")
                    }
                }
                
                if case .finished = completion {
                    print(completion)
                }
                
            } receiveValue: { [weak self] (loggedUser) in
            
                self?.loggedUser.send(loggedUser)
                
                self?.userSkills.send(SkillsModelArray(skillsModel: loggedUser.skills))
                
                self?.statePublisher.send(StateOfNetworking.loaded)
            }.store(in: &bag)
    }
    
    func setSkillsForUser(by id: String, skillArray: [Skill]) {
        var newSkills = SkillsV2()
        skillArray.forEach { (skill) in
            if skill.type == "ios" {
                newSkills.ios = skill.value
            }
            if skill.type == "swift" {
                newSkills.swift = skill.value
            }
            if skill.type == "android" {
                newSkills.android = skill.value
            }
            if skill.type == "kotlin" {
                newSkills.kotlin = skill.value
            }
        }
        
        StudentAccountRepository.setSkills(by: id, skills: newSkills )
            .sink { [weak self] (completion) in
                switch completion {
                case .finished:
                    print(completion)
                case .failure(let err):
                    print("Retrieving data failed with error \(err)")
                    if err as! NetworkServiceError == .apiError {
                        self?.statePublisher.send(StateOfNetworking.error(err))
                        print("### Retrieving data failed with error \(err)")
                    } else if err as! NetworkServiceError == .unauthorizedUser {
                        //If user is unauthorized 
                        self?.statePublisher.send(StateOfNetworking.unauthorized)
                        print("### Retrieving data failed with error \(err)")
                    }
                    // if all skill removed send empty skills
                    self?.userSkills.send(SkillsModelArray(skillsModel: SkillsV2()))
                }
            } receiveValue: { [weak self] (skills) in
                self?.userSkills.send(SkillsModelArray(skillsModel: skills))
                print("skills\(skills)")
            }
            .store(in: &bag)
    }
    
}
