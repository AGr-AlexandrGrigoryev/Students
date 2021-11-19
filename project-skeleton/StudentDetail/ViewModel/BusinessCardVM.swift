//
//  BusinessCardVM.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 01.04.2021.
//

import Foundation
import Combine

class BusinessCardVM: BusinessCardVMType {
    
    var statePublisher = PassthroughSubject<StateOfNetworking, Never> ()
    let student = PassthroughSubject <BusinessCardModelAPIv2, Never>()
    private var bag = Set<AnyCancellable>()
    
    func loadStudent(by id: String) {
        self.statePublisher.send(StateOfNetworking.isLoading)
        
        StudentDetailRepository.fetchStudent(by: id)
            .sink { [weak self] (completion) in
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                    if err as! NetworkServiceError == .apiError {
                        self?.statePublisher.send(StateOfNetworking.error(err))
                        print("### Retrieving data failed with error \(err)")
                    } else if err as! NetworkServiceError == .unauthorizedUser {
                        self?.statePublisher.send(StateOfNetworking.unauthorized)
                        print("### Retrieving data failed with error \(err)")
                    }
                }
                if case .finished = completion {
                    print(completion)
                }
            } receiveValue: { [weak self] (value) in
                let student =
                    BusinessCardModelAPIv2(
                        name: value.name,
                        participantType: value.participantType,
                        title: value.title,
                        slackURL: value.slackURL,
                        icon512: value.icon512,
                        skills: value.skills,
                        homework: value.homework)
                self?.student.send(student)
            }
            .store(in: &self.bag)
    }
}
