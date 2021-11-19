//
//  StudentListVMType.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 21.04.2021.
//

import Foundation
import Combine

protocol StudentListVMType {
    
    var statePublisher: PassthroughSubject<StateOfNetworking, Never> { get }
    var students: PassthroughSubject<[StudentCellView.Content], Never> { get }
    var filter: PassthroughSubject<Int , Never> { get }
    var allStudents: PassthroughSubject<[StudentCellView.Content], Never> { get }
    
    func loadStudentsList()
    func bind()
    
}
