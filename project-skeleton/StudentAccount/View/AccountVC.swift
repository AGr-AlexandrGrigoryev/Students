//
//  AccountVC.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 30.03.2021.
//

import UIKit
import Combine

class AccountVC: UIViewController {
    
    static var isTaped: (() -> Void)?
    private var bag = Set<AnyCancellable>()
    
    //MARK: - View for view controller
    private let scrollView = UIScrollView()
    let contentView = AccountView()
    var skills = SkillsModelArray()
    private let loginVM = LoginVM()
    
    private let noDataLabel = NoDataLabel()
    private lazy var tryAgainButton: TryAgainButton  = {
        let button = TryAgainButton(type: .system)
        button.addTarget(self, action: #selector(refreshDataButtonAction), for: .touchUpInside)
        return button
    }()

    //MARK: - Live cycle of view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationController?.isNavigationBarHidden = true
        
        view.addSubview(scrollView)
        self.scrollView.addSubview(self.contentView)
        setupConstraints()
        
        logOut()
        render()
        setupBindings()
        contentView.buttonAction = {
            self.presentAllert(skills: self.skills)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.viewModel.loadLoggedUser(by: Auth.userDefaults.userId ?? "")
        self.contentView.isHidden = false
    }
    
    //MARK: - Functions of view controller
    func setupBindings()  {
        contentView.viewModel.userSkills
            .sink { (skills) in
                self.skills = skills
            }
            .store(in: &bag)
    }
    
    private func render() {
        contentView.viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { (state) in
                switch state {
                case .isLoading:
                    print("### isLoading...")
                    self.contentView.isHidden = true
                    self.view.showLoading()
                case .error(let error):
                    print("### Error is \(error)")
                    // refresh button appears, after clicking on button data reloads
                    self.view.stopLoading()
                    self.contentView.removeFromSuperview()
                    self.appearRefreshButton()
                case .loaded:
                    print("### loaded")
                    self.view.stopLoading()
                    self.contentView.isHidden = false

                case .authorized:
                    print("### authorized")
                    
                case .unauthorized:
                    guard let userId = Auth.userDefaults.userId,
                          let password = Auth.userDefaults.password else { return }
                    
                    self.loginVM.login(userName: userId , password: password)
                    self.contentView.viewModel.loadLoggedUser(by: Auth.userDefaults.userId ?? "")
                    print("### unauthorized")
                    
                case .loggedOut:
                    print("### loggedOut")
                }
            }
            .store(in: &bag)
    }
    
    
    private func logOut() {
        AccountVC.isTaped = { [weak self]  in
            print("Did tapped from vc")

            //Create alert for user with message:
            let actionSheet = UIAlertController(
                title: "Warning message:",
                message: "Do you really want to Log out ?",
                preferredStyle: .actionSheet)
        
            // Add action log out, if user really want to log out:
            actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
                // set user credential to nil and present login screen
                Auth.userDefaults.accessToken = nil
                Auth.userDefaults.userId = nil
                Auth.userDefaults.password = nil
                self?.contentView.viewModel.statePublisher.send(StateOfNetworking.unauthorized)
                self?.present(LoginVC(), animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self?.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func presentAllert(skills: SkillsModelArray) {
        let actionSheet = UIAlertController(
            title: "Add Skils:",
            message: "Do you really want add skills ?",
            preferredStyle: .actionSheet)
        
        if skills.skillsModel?.android == nil {
            actionSheet.addAction(
                UIAlertAction(
                    title: "Android",
                    style: .destructive,
                    handler: { [unowned self] _ in
                        contentView.currentSkills.append(
                            Skill(type: "android",
                                  value: 0))
                        
                        contentView.viewModel.setSkillsForUser(
                            by: Auth.userDefaults.userId ?? "",
                            skillArray: contentView.currentSkills)
                    }))
        }
        
        if skills.skillsModel?.kotlin == nil {
            actionSheet.addAction(
                UIAlertAction(
                    title: "Kotlin",
                    style: .destructive,
                    handler: { [unowned self] _ in
                        contentView.currentSkills.append(
                            Skill(type: "kotlin",
                                  value: 0))
                        
                        contentView.viewModel.setSkillsForUser(
                            by: Auth.userDefaults.userId ?? "",
                            skillArray: contentView.currentSkills)
                    }))
        }
        
        if skills.skillsModel?.ios == nil {
            actionSheet.addAction(
                UIAlertAction(
                    title: "iOS",
                    style: .destructive,
                    handler: { [unowned self] _ in
                        contentView.currentSkills.append(
                            Skill(type: "ios",
                                  value: 0))
                        
                        contentView.viewModel.setSkillsForUser(
                            by: Auth.userDefaults.userId ?? "",
                            skillArray: contentView.currentSkills)
                    }))
        }
        
        if skills.skillsModel?.swift == nil {
            actionSheet.addAction(
                UIAlertAction(
                    title: "Swift",
                    style: .destructive,
                    handler: { [unowned self] _ in
                        contentView.currentSkills.append(
                            Skill(type: "swift",
                                  value: 0))
                        
                        contentView.viewModel.setSkillsForUser(
                            by: Auth.userDefaults.userId ?? "",
                            skillArray: contentView.currentSkills)
                    }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - Extension for view controller
extension AccountVC {
    
    @objc func refreshDataButtonAction() {
        tryAgainButton.removeFromSuperview()
        noDataLabel.removeFromSuperview()
        view.showLoading()
        contentView.viewModel.loadLoggedUser(by: Auth.userDefaults.userId ?? "")
        self.scrollView.addSubview(self.contentView)
        self.setupConstraints()
    }
        
    private func appearRefreshButton () {
        [tryAgainButton,noDataLabel].forEach{view.addSubview($0)}
        [tryAgainButton,noDataLabel].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tryAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tryAgainButton.topAnchor.constraint(equalTo: noDataLabel.bottomAnchor, constant: 20),
        ])
    }
        
    private func setupConstraints() {
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        
        [scrollView, contentView].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
 
            frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frameGuide.topAnchor.constraint(equalTo: view.topAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            frameGuide.widthAnchor.constraint(equalTo: contentGuide.widthAnchor)
        ])
    }
}
