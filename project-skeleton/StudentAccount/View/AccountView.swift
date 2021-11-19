//
//  AccountView.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 09.04.2021.
//

import UIKit
import Combine

class AccountView: UIView {
    public var viewModel = AccountVM()
    private var bag = Set<AnyCancellable>()
    var buttonAction: (()->Void)?
    
    private let name = AccountLabels()
    private let profession = AccountLabels()
    private let line = UIView()
    private let accountButtons = AccountButtons()
    private let skillsLabel = AccountLabels()
    
    private let tipsLabel = AccountLabels()
    private var noSkillsImage = UIImageView()
    private let addSkillButton = AccountButtons().setupEditSkillsButton()
    
    var currentSkills = [Skill]()
    
    // Padding and Spacing for constraints
    let padding: CGFloat = 20
    let spacing: CGFloat = 10
    
    private lazy var skillsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    public lazy var logOutButton: UIButton  = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "log out"), for: .normal)
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        addSkillButton.addTarget(self, action: #selector(retryButtonClicked), for: .touchUpInside)
        setupUI()
        setupBindings()
        skillBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        line.backgroundColor = UIColor.systemGray4
        skillsLabel.setupSkillsLabel("Dovednosti")
        tipsLabel.setupTipsLabel("Pro smazání dovednosti, podržte ji vteřinu 🐾")
        setupNoSkillsImage()
        
        [name, profession, line, logOutButton, skillsLabel, skillsStackView, tipsLabel, addSkillButton]
            .forEach{ addSubview( $0)}
        setupConstraints()
    }
    
    func setupBindings() {
        viewModel.loggedUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (user) in
                self?.name.setUpLoggedUserNameLabel2(with: user.name)
                self?.profession.setUpLoggedUserProfessionLabel(with: user.title)
                self?.setupSkillLevel(for: SkillsModelArray(skillsModel: user.skills).getSkillsArray())
                self?.currentSkills = SkillsModelArray(skillsModel: user.skills).getSkillsArray()
            }
            .store(in: &bag)
    }
    
    private func skillBindings() {
        viewModel.skillSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (skill) in
                if var tempArray = self?.currentSkills {
                    let index = tempArray.firstIndex{ (currentSkill) -> Bool in
                        currentSkill.type == skill.type
                    }
                    tempArray.removeAll { (currentSkill) -> Bool in
                        currentSkill.type == skill.type
                    }
                    tempArray.insert(skill, at: index ?? 0)
                    // Set new skills
                    self?.viewModel.setSkillsForUser(by: Auth.userDefaults.userId ?? "", skillArray: tempArray)
                    print(skill)
                }
            }
            .store(in: &bag)
        
        viewModel.userSkills
            .receive(on: DispatchQueue.main)
            .sink { (skillsModel) in
                self.currentSkills = skillsModel.getSkillsArray()
                self.setupSkillLevel(for: skillsModel.getSkillsArray())
            }
            .store(in: &bag)
    }
    
    private func setupSkillLevel(for level: [Skill]) {
        if skillsStackView.arrangedSubviews.isEmpty {
            tipsLabel.isHidden = true
            noSkillsImage.isHidden = false
        }
        if level.count == 4 {
            addSkillButton.isHidden = true
        } else {
            addSkillButton.isHidden = false
        }
        // remove all skill view before setup new skills
        skillsStackView.arrangedSubviews.forEach{ $0.removeFromSuperview()}
        
        level.forEach { (skill) in
            if let skillValue = skill.value, let skillName = skill.type {
                let view = AccountSkillView(frame: .zero, skill: skill, viewModel: viewModel)
                //Setup skill view with photo and level of skills
                view.setupProgressLevelUI(for: skillName, for: skillValue)
                //add skill to stack view
                skillsStackView.addArrangedSubview(view)
                tipsLabel.isHidden = false
                noSkillsImage.isHidden = true
                
            }
        }
    }
}

extension AccountView {
    
    @objc func logOut() {
        print("Did taped")
        AccountVC.isTaped?()
    }
    
    @objc func retryButtonClicked(){
        buttonAction?()
      }
    
    private func setupNoSkillsImage() {
        noSkillsImage.image = UIImage(named: "laptop_element")
        addSubview(noSkillsImage)
        
        noSkillsImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noSkillsImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 300),
            noSkillsImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            noSkillsImage.heightAnchor.constraint(equalToConstant: 145),
            noSkillsImage.widthAnchor.constraint(equalToConstant: 180),
        ])
    }
    
    /// Setup constraint for views
    private func setupConstraints() {
        [name, profession, line, logOutButton, skillsLabel, skillsStackView, tipsLabel , addSkillButton]
            .forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            // constrains for name of user
            name.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 35),
            name.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: padding),
            name.widthAnchor.constraint(equalToConstant: 300),
            //name.heightAnchor.constraint(equalToConstant: 33),
            
            // constrains for profession of user
            profession.topAnchor.constraint(equalTo: name.bottomAnchor, constant: spacing),
            profession.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: padding),
            profession.heightAnchor.constraint(equalToConstant: 15),
            profession.widthAnchor.constraint(equalToConstant: 100),
            
            // constrains for separate line
            line.topAnchor.constraint(equalTo: profession.bottomAnchor, constant: 40),
            line.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: padding),
            line.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor,constant: -padding),
            line.heightAnchor.constraint(equalToConstant: 1),
            
            // constrains for logout button
            logOutButton.bottomAnchor.constraint(equalTo: name.bottomAnchor, constant: -5),
            logOutButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -padding),
            logOutButton.heightAnchor.constraint(equalToConstant: 20),
            logOutButton.widthAnchor.constraint(equalToConstant: 20),
            
            // constrains for edit skill button
            addSkillButton.topAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant: spacing * 2 + 10),
            addSkillButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -padding),
            addSkillButton.heightAnchor.constraint(equalToConstant: 25),
            addSkillButton.widthAnchor.constraint(equalToConstant: 25),
            
            // constrains for skill label
            skillsLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: spacing),
            skillsLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: padding),
            skillsLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            
            // constrains for skill stack view
            skillsStackView.topAnchor.constraint(equalTo: skillsLabel.safeAreaLayoutGuide.bottomAnchor, constant: spacing),
            skillsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            skillsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            skillsStackView.bottomAnchor.constraint(equalTo: tipsLabel.safeAreaLayoutGuide.topAnchor, constant: -padding),
            
            // constrains for tips label
            tipsLabel.topAnchor.constraint(equalTo: skillsStackView.bottomAnchor, constant: spacing * 2),
            tipsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tipsLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }
}

