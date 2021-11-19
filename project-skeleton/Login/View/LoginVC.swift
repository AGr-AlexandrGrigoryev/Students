//
//  LoginVC.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 05.04.2021.
//

import UIKit
import Combine


class LoginVC: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    static var isTaped: (() -> Void)?
    
    private var loginView = LoginView()
    private var viewModel = LoginVM()
    var listViewModel = StudentListVM()
    
    private var loginImage = LoginImage(frame: .zero)
    
    private var userNameDescription = UILabel()
    private let userNameTextField = UITextField()
    
    private var passwordDescription = UILabel()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private var noIdDescription = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""  // "alexandr.grigoryev"
        passwordTextField.text = "" // "NTePoRY"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        render()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        isModalInPresentation = true
        
        // tapping anywhere on the view controller to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        loginImage.setupImage()
        
        // setup textFields
        userNameDescription = loginView.setupDescriptionLabel("Account ID")
        passwordDescription = loginView.setupDescriptionLabel("Password")
        noIdDescription = loginView.setupDescriptionIdLabel()
        
        userNameTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        userNameTextField.autocapitalizationType = .none
        passwordTextField.autocapitalizationType = .none
        
        loginView.setupTextField(for: userNameTextField, with: "Enter your account ID", secure: false)
        loginView.setupTextField(for: passwordTextField, with: "Enter your password", secure: true)
        
        loginView.setupLoginButton(button: loginButton)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        [loginImage, userNameDescription, userNameTextField, passwordDescription, passwordTextField, loginButton, noIdDescription].forEach{view.addSubview($0)}
    }
    
    func userNameIsValid() -> Bool {
        guard let userName = userNameTextField.text else {
            return false
        }
        return userName.rangeOfCharacter(from: .alphanumerics) != nil && userName.count > 3 ? true : false
    }
    func passwordIsValid() -> Bool {
        guard let password = passwordTextField.text else {
            return false
        }
        return password.rangeOfCharacter(from: .alphanumerics) != nil && password.count > 6 ? true : false
    }
    
    func render() {
        viewModel.loginState
            .sink { [weak self] (error) in
                print("credentials error")
                self?.showCredentialsAlert()
            }
            .store(in: &bag)
    }
}

extension LoginVC {
    @objc private func loginButtonTapped() {
        if userNameIsValid() && passwordIsValid() {
            print(userNameTextField.text as Any )
            print(passwordTextField.text as Any )
        viewModel.login(userName: self.userNameTextField.text ?? "", password: self.passwordTextField.text ?? "")
        // Show alert for user about login rules
        } else {
            showAlert()
            print(" enter correct credentials")
        }
        LoginVC.isTaped = {
            guard Auth.userDefaults.accessToken != nil else {
                return print(" failed to login")
            }
            // If user logged out from account, navigate him to Students screen
            if let tabBarController = self.presentingViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
            }
            // Dissmiss modal view of login and load data
            self.dismiss(animated: true) {
                self.listViewModel.loadStudentsList()
            }
        }
    }
    
    private func showAlert () {
        //Create alert for user with message:
        let actionSheet = UIAlertController(
            title: "Warning message 🙇‍♂️",
            message: "Your 🙎‍♂️ name should have a minimum of 3️⃣🔤 and a 🔑 minimum of 6️⃣🔤",
            preferredStyle: .alert)
    
        // Add action
        actionSheet.addAction(UIAlertAction(title: "Try again 🙏 ", style: .default, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showCredentialsAlert () {
        //Create alert for user with message:
        let actionSheet = UIAlertController(
            title: "Login failed 🎟",
            message: "You've entered an invalid 🙎‍♂️ or 🔑",
            preferredStyle: .alert)
    
        // Add action
        actionSheet.addAction(UIAlertAction(title: "Try again 🙏 ", style: .default, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        [loginImage, loginButton, userNameDescription, userNameTextField,passwordDescription, passwordTextField, noIdDescription]
            .forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            
            loginImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginImage.heightAnchor.constraint(equalToConstant: 170),
            loginImage.widthAnchor.constraint(equalToConstant: 170),
            loginImage.bottomAnchor.constraint(equalTo: userNameTextField.topAnchor, constant: -65),
            
            userNameDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userNameDescription.bottomAnchor.constraint(equalTo: userNameTextField.topAnchor, constant: -5),
            
            userNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            userNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordDescription.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -5),
            
            passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            noIdDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noIdDescription.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
