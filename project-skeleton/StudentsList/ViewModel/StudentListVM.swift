//
//  StudentListVM.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 01.04.2021.
//

import Foundation
import Combine

class StudentListVM: StudentListVMType {
    
    var statePublisher = PassthroughSubject<StateOfNetworking, Never> ()
    var students = PassthroughSubject< [StudentCellView.Content], Never>()
    var filter = PassthroughSubject< Int , Never>()
    internal var allStudents = PassthroughSubject< [StudentCellView.Content], Never>()
    
    private let filterMap: [Int: ParticipantType] = [0: .all, 1: .iosStudent, 2: .androidStudent]
    private var bag = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func loadStudentsList() {
        statePublisher.send(StateOfNetworking.isLoading)
        
        StudentsListRepository.fetchStudents()
            .print("### Get students")
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                    if err as! NetworkServiceError == .apiError {
                        self.statePublisher.send(StateOfNetworking.error(err))
                        print("### Retrieving data failed with error \(err)")
                    } else if err as! NetworkServiceError == .unauthorizedUser {
                        //if user unauthorized autorize him
                        self.statePublisher.send(StateOfNetworking.unauthorized)
                        print("### Retrieving data failed with error \(err)")
                    }
                }
                if case .finished = completion {
                    print(completion)
                }
            }, receiveValue: { [weak self] studentsArray in
               
                let students = studentsArray.map {
                    StudentCellView
                        .Content(
                            id: $0.id,
                            name: $0.name,
                            participantType: $0.participantType,
                            icon192: $0.icon192,
                            homework: $0.homework)
                }
                self?.allStudents.send(students)
                self?.statePublisher.send(StateOfNetworking.loaded)
                
            })
            .store(in: &bag)
    }
    
    internal func bind() {
        filter.combineLatest(allStudents)
            .print("Filter")
            .sink(receiveValue: { [weak self] (filter, students)  in
                print("### filter \(filter)")
                let filtered = students.filter{ student in
                    return student.participantType == self?.filterMap[filter] || filter == 0
                }
                print("### sending \(students.count) students")
                print("### android \(filtered.filter { $0.participantType == .androidStudent }.count) students")
                self?.students.send(filtered)
            })
            .store(in: &bag)
    }
}


