//
//  AccountSkillView.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 13.04.2021.
//

import UIKit
import Combine

class AccountSkillView: UIView {
    
    private var bag = Set<AnyCancellable>()
    
    public var skillType: String?
    private let mainView = UIView()
    private let platformImageView = UIImageView()
    private let skillRatingLabel = UILabel()
    
    private let stepper = AccountButtons.setupStepper()
    
    var viewModel: AccountVM?
    
    private lazy var horizontalSkillProgressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.layer.cornerRadius = 6
        stackView.clipsToBounds = true
        return stackView
    }()
    
    init(frame: CGRect, skill: Skill, viewModel: AccountVM) {
        self.viewModel = viewModel
        self.skillType = skill.type
        
        self.stepper.value = Double(skill.value ?? 0)
        super.init(frame: .zero)
        
        mainView.layer.cornerRadius = 25
        mainView.backgroundColor = UIColor(named: "LevelSkillViewBackground")
        addSubview(mainView)
        
        stepper.addTarget(self, action: #selector(updateSkill), for: .valueChanged)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(removeSelectedSkill))
        longPressGesture.minimumPressDuration = 0.5
        mainView.addGestureRecognizer(longPressGesture)
        
        mainView.addSubview(stepper)
        setupConstraints(for: stepper)
        setupConstraintsForMainView()
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupProgressLevelUI(for image: String, for level: Int) {
        platformAvatar(image)
        skillProgressLevel(level)
    }
        
    private func platformAvatar (_ image: String) {
        platformImageView.image = UIImage(named: image)

        mainView.addSubview(platformImageView)
        
        platformImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            platformImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            platformImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            platformImageView.heightAnchor.constraint(equalToConstant: 30),
            platformImageView.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func skillProgressLevel(_ level: Int) {
        // setup orange color if user have one or more active skills
        if level != 0 {
            let templateImage = platformImageView.image?.withRenderingMode(.alwaysTemplate)
            platformImageView.image = templateImage
            platformImageView.tintColor = UIColor(named: "LevelSkillLabelColor")
        }
        
        setupSkillProgressLevel(level)
        mainView.addSubview(horizontalSkillProgressStackView)
        
        horizontalSkillProgressStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalSkillProgressStackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            horizontalSkillProgressStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -45),
            horizontalSkillProgressStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 45),
            horizontalSkillProgressStackView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func setupConstraintsForMainView() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 135),
        ])
        
    }
    
    /// Function for creating constraints of a stepper which will appear on skill view
    /// - Parameters:
    ///   - stepper: UIStepper for current view
    ///   - view: view for setup constraints
    private func setupConstraints(for stepper: UIStepper){
        NSLayoutConstraint.activate([
            stepper.centerXAnchor.constraint(equalTo: centerXAnchor),
            stepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    @objc
    func updateSkill()  {
        let skill = Skill(type: skillType, value: Int(stepper.value))
        guard let viewModel = viewModel else {
            return
        }
         viewModel.skillSubject
            .send(skill)
            
        setupSkillProgressLevel(Int(stepper.value))
        let generator = UIImpactFeedbackGenerator(style: .heavy)
           generator.impactOccurred()
    }
    
    @objc
    func removeSelectedSkill() {
        // Animate skill view while deleting
        mainView.flash()
        mainView.shake()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            viewModel?.skillSubject.send(Skill(type: skillType, value: nil))
        }
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
           generator.impactOccurred()
    }
    
    func setupSkillProgressLevel(_ level: Int) {
        // create 10 small views 
        while horizontalSkillProgressStackView.arrangedSubviews.count < 10 {
            let smallView = UIView()
            smallView.frame.size.height = 13
            smallView.frame.size.width = 13
            smallView.backgroundColor = .systemGray3
            horizontalSkillProgressStackView.addArrangedSubview(smallView)
        }
        
        //set orange color for skills from 0 to level of skills
        for view in 0..<level {
                self.horizontalSkillProgressStackView.subviews[view].backgroundColor = UIColor(named: "LevelSkillLabelColor")
        }
    }
    
}

