//
//  LoginVM.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 12.04.2021.
//

import Foundation
import Combine

class LoginVM : LoginVMType {
    
    let nameInput = PassthroughSubject<String, Never>()
    let passwordInput = PassthroughSubject<String, Never>()
    
    var loginState = PassthroughSubject<LoginError, Never> ()
    static var bag = Set<AnyCancellable>()
    var bag = Set<AnyCancellable>()
    let repository = LoginRepository()
    private var listViewModel = StudentListVM()
        
    func login(userName: String, password: String)  {
        LoginRepository.fetchAccessToken(userName: userName, password: password)
            .sink { (completion) in
                if case .failure(let error) = completion {
                    print("Retrieving data failed with error \(error)")
                    self.loginState.send(LoginError.invalidCredentials)
                }
            } receiveValue: { (value) in
                Auth.userDefaults.accessToken = value.accessToken
                Auth.userDefaults.userId = userName
                Auth.userDefaults.password = password
                print("######### token is: \(String(describing: Auth.userDefaults.accessToken))")
                
                self.listViewModel.statePublisher.send(StateOfNetworking.authorized)
                LoginVC.isTaped?()
            }
            .store(in: &bag)
    }
}
