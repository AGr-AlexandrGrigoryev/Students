//
//  StudentDetailView.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 15.03.2021.
//

import UIKit
import Combine

class StudentDetailView: UIView {
    private var bag = Set<AnyCancellable>()
    let bcViewModel = BusinessCardVM()
    
    private var isPushed = false
    private var isReviewed = false
    private var isAccepted = false

    //MARK: - Views for  BusinessCardView
    private let horizontalScrollview = UIScrollView()

    private let userImage = StudentDetailImage(frame: .zero)
    private let professionLabel = StudentDetailLabels()
    
    private let slackButton = StudentDetailButtons()
    private let emailButton = StudentDetailButtons()
    private let linkedInButton = StudentDetailButtons()
        
    private let line = UIView()
    private let skillsLabel = StudentDetailLabels("Dovednosti")
    
    private let noSkillsImage = SkillsView()
    private let skillsView = SkillsView()
    private let skillsView2 = SkillsView()
    private let skillsView3 = SkillsView()
    private let skillsView4 = SkillsView()
   
    private let homeWorksLabel = StudentDetailLabels(tasks: "Úkoly")
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [slackButton, emailButton, linkedInButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 48
        return stackView
    }()
    
    private lazy var skillsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.backgroundColor = UIColor(named: "LevelSkillViewBackground")
        stackView.layer.cornerRadius = 25
        return stackView
    }()
    
    private var contentOfHorizontalView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        setupUIForVerticalView()
        setupBindings()
        setupUIForHorizontalView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupBindings() {
        bcViewModel.student
            .sink {  student in
                self.professionLabel.setUpProfessionLabel2(for: student.title  )
                self.userImage.setupUI2(for: student.icon512)
                self.slackButton.setupButton(for: .slack, with: student.slackURL)
                self.emailButton.setupButton(for: .email, with: nil)
                self.linkedInButton.setupButton(for: .linkedIn, with: nil)
                    
                self.setupProgressV2(of: student.skills ?? nil)

                _ = student.homework.map { (homework)  in
                    self.setupContentOfHorizontalView(with: homework)
                    
                }
                self.bcViewModel.statePublisher.send(StateOfNetworking.loaded)
            }
            .store(in: &bag)
    }
    
    private func setupProgressV2(of skills: SkillsV2?) {
        guard skills != nil else {
            noSkillsImage.setupNoSkillsImage()
            skillsStackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
            skillsStackView.addArrangedSubview(noSkillsImage)
            return
        }
        noSkillsImage.removeFromSuperview()
        /*
        If user have this skill, setup UI for this skill and,
        add to stack view this skill
        */
        if skills?.ios != nil  {
            skillsView.setupProgressLevelUI(for: "ios", for: (skills?.ios)!)
            skillsStackView.addArrangedSubview(skillsView)
        } else {
            skillsView.removeFromSuperview()
        }
        
        if skills?.swift != nil  {
            skillsView2.setupProgressLevelUI(for: "swift", for: (skills?.swift)!)
            skillsStackView.addArrangedSubview(skillsView2)
        } else {
            skillsView2.removeFromSuperview()
        }
        
        if skills?.android != nil  {
            skillsView3.setupProgressLevelUI(for: "android", for: (skills?.android)!)
            skillsStackView.addArrangedSubview(skillsView3)
        } else {
            skillsView3.removeFromSuperview()
        }
        
        if skills?.kotlin != nil  {
            skillsView4.setupProgressLevelUI(for: "kotlin", for: (skills?.kotlin)!)
            skillsStackView.addArrangedSubview(skillsView4)
        } else {
            skillsView4.removeFromSuperview()
        }
    }
    
    private func setupProgress(of skills: Skills) {
        if skills.skillType == "swift" {
            print(skills.value)
            self.skillsView.setupProgressLevelUI(for: "swift", for: skills.value)
        } else if skills.skillType == "kotlin"{
            self.skillsView.setupProgressLevelUI(for: "kotlin", for: skills.value)
        } else if skills.skillType == "ios" {
            self.skillsView2.setupProgressLevelUI(for: "ios", for: skills.value)
        } else if skills.skillType == "android" {
            self.skillsView3.setupProgressLevelUI(for: "android", for: skills.value)
        }
    }
    
    func setupContentOfHorizontalView(with homework: HomeWork) {
        let homeWorksView = HomeWorksView()

        switch homework.state {
        case .acceptance:
            isPushed = true; isReviewed = true; isAccepted = true
            break
        case .review:
            isPushed = true; isReviewed = true; isAccepted = false
            break
        case .push:
            isPushed = true; isReviewed = false; isAccepted = false
            break
        case .comingsoon:
            isPushed = false; isReviewed = false; isAccepted = false
            break
        case .ready:
            isPushed = false; isReviewed = false; isAccepted = false
            break
        }
        
        homeWorksView.setupCheckmarkIconFor(push: isPushed, review: isReviewed, acceptance: isAccepted)
        homeWorksView.setupNumberOf(String(homework.number))
        homeWorksView.setupUI()
        homeWorksView.setupConstraints()
        
        // Add views of homework to horizontal view
        contentOfHorizontalView.addArrangedSubview(homeWorksView)
    }
    
    private func setupUIForVerticalView () {
        [userImage, professionLabel, buttonsStackView, line, skillsLabel, skillsStackView, homeWorksLabel].forEach{
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupUIForHorizontalView () {
        contentOfHorizontalView.distribution = .fillEqually
        contentOfHorizontalView.axis = .horizontal
        contentOfHorizontalView.spacing = 20
        
        horizontalScrollview.showsHorizontalScrollIndicator = false
        
        addSubview(horizontalScrollview)
        horizontalScrollview.addSubview(contentOfHorizontalView)
        [horizontalScrollview, contentOfHorizontalView].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
}

extension StudentDetailView {
    private func setupConstraints() {
        line.backgroundColor = UIColor.systemGray4
        NSLayoutConstraint.activate([
            
            // constrains for image of user
            userImage.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            userImage.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            userImage.heightAnchor.constraint(equalToConstant: 200),
            userImage.widthAnchor.constraint(equalToConstant: 200),
            
            // constrains for profession of user
            professionLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),
            professionLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            professionLabel.widthAnchor.constraint(equalToConstant: 350),
            professionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // constrains for social media buttons
            buttonsStackView.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 20),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 250),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            // constrains for separate line
            line.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 40),
            line.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 10),
            line.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor,constant: -10),
            line.heightAnchor.constraint(equalToConstant: 1),
            
            // constrains for skill label
            skillsLabel.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 10),
            skillsLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 20),
            skillsLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            // constrains for stack of skills
            skillsStackView.topAnchor.constraint(equalTo: skillsLabel.bottomAnchor, constant: 10),
            skillsStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 10),
            skillsStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -10),

            // constrains for home work
            homeWorksLabel.topAnchor.constraint(equalTo: skillsStackView.bottomAnchor, constant: 10),
            homeWorksLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 20),
            homeWorksLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            // constraints for scrollview
            horizontalScrollview.topAnchor.constraint(equalTo: homeWorksLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            horizontalScrollview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            horizontalScrollview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            horizontalScrollview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            //constraints for content of horizontal scroll view
            contentOfHorizontalView.topAnchor.constraint(equalTo: horizontalScrollview.topAnchor),
            contentOfHorizontalView.leadingAnchor.constraint(equalTo: horizontalScrollview.leadingAnchor, constant: 20),
            contentOfHorizontalView.trailingAnchor.constraint(equalTo: horizontalScrollview.trailingAnchor),
            contentOfHorizontalView.bottomAnchor.constraint(equalTo: horizontalScrollview.bottomAnchor),
            
            // constraints for horizontal scrolling
            contentOfHorizontalView.heightAnchor.constraint(equalTo: horizontalScrollview.heightAnchor),
        ])
    }
}
