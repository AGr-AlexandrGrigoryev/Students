//
//  BusinessCardVMType.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 21.04.2021.
//

import Foundation
import Combine
protocol BusinessCardVMType {
    
    var statePublisher: PassthroughSubject<StateOfNetworking, Never> { get }
    var student: PassthroughSubject <BusinessCardModelAPIv2, Never> { get }
    
    func loadStudent(by id: String)
}
