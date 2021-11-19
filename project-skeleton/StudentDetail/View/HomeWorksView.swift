//
//  HomeWorksView.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 18.03.2021.
//

import UIKit

class HomeWorksView: UIView {
    
    //MARK:  Views for main view of homework
    private let numberOfTaskView = UIView()
    private var pushLabel = UILabel()
    private var reviewLabel = UILabel()
    private var acceptanceLabel = UILabel()
    private var pushCheckmarkIcon = UIImageView()
    private var reviewCheckmarkIcon = UIImageView()
    private var acceptanceCheckmarkIcon = UIImageView()
    
    let leftPadding: CGFloat = 20
    let rightPadding: CGFloat = -20
    
    /// Initializer for homework view
    init() {
        super.init(frame: .zero)
        setupProgressLabels()
    }
        
    /// Set up UI for represent view
     func setupUI() {
        layer.cornerRadius = 25
        backgroundColor = UIColor(named: "LevelSkillViewBackground")
        
        [pushLabel, reviewLabel, acceptanceLabel, pushCheckmarkIcon, reviewCheckmarkIcon,
         acceptanceCheckmarkIcon , numberOfTaskView].forEach{addSubview($0)}
        
        [pushLabel, reviewLabel, acceptanceLabel, pushCheckmarkIcon, reviewCheckmarkIcon,
         acceptanceCheckmarkIcon, numberOfTaskView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }
    
    /// Set up the label of state of progress
    /// - Parameter name: name of this label
    /// - Returns: label
    private func setupLabel(_ name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor.systemGray3
        return label
    }
    
    /// Set up the value for progress labels
    func setupProgressLabels() {
        pushLabel = setupLabel("PUSH")
        reviewLabel = setupLabel("REVIEW")
        acceptanceLabel = setupLabel("ACCEPTANCE")
    }
    
    /// Set up the image and their color for checkmark icons which represent the completion parts of homework.
    /// - Parameters:
    ///   - push: value if student pushed his homework to git
    ///   - review: value  if homework has been reviewed
    ///   - acceptance: value if homework has been accepted
    func setupCheckmarkIconFor(push: Bool, review: Bool, acceptance: Bool) {
        let completeIcon = UIImage(systemName: "checkmark.circle.fill")
        let notCompleteIcon = UIImage(systemName: "clock.fill")
        
        guard let complete = completeIcon, let notComplete = notCompleteIcon  else { return  }
        
        [complete, notComplete].forEach{ $0.withRenderingMode(.alwaysTemplate) }
              
        if push {
            pushCheckmarkIcon = UIImageView(image: complete)
            pushCheckmarkIcon.tintColor = UIColor(named: "LevelSkillLabelColor")
        } else {
            pushCheckmarkIcon = UIImageView(image: notComplete)
            pushCheckmarkIcon.tintColor = .systemGray2
        }
        
        if review {
            reviewCheckmarkIcon = UIImageView(image: complete)
            reviewCheckmarkIcon.tintColor = UIColor(named: "LevelSkillLabelColor")
        } else {
            reviewCheckmarkIcon = UIImageView(image: notComplete)
            reviewCheckmarkIcon.tintColor = .systemGray2
        }
        
        if acceptance {
            acceptanceCheckmarkIcon = UIImageView(image: complete)
            acceptanceCheckmarkIcon.tintColor = UIColor(named: "LevelSkillLabelColor")
        } else {
            acceptanceCheckmarkIcon = UIImageView(image: notComplete)
            acceptanceCheckmarkIcon.tintColor = .systemGray2
        }
    }
    
    /// Set up the number fo homework
    /// - Parameter task: label represents the number of homework
    func setupNumberOf(_ task: String?) {
        let numberLabel = UILabel()
        numberLabel.text = task
        numberLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        numberLabel.numberOfLines = 0
        numberLabel.textColor = .white
        
        numberOfTaskView.backgroundColor = UIColor(named: "numberOfTaskColor")
        numberOfTaskView.layer.cornerRadius = 25
        
        addSubview(numberOfTaskView)
        numberOfTaskView.addSubview(numberLabel)
        
        //Setups the constraints for number of label
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.centerXAnchor.constraint(equalTo: numberOfTaskView.centerXAnchor).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: numberOfTaskView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:  Extension for homework's view
extension HomeWorksView {
    
    /// Setups the constraints for the view
     func setupConstraints() {
        NSLayoutConstraint.activate([
            
            //Setups the constraints for height and width of view
            heightAnchor.constraint(equalToConstant: 180),
            widthAnchor.constraint(equalToConstant: 190),
            
            //Setups the constraints for number of homework
            numberOfTaskView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            numberOfTaskView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            numberOfTaskView.heightAnchor.constraint(equalToConstant: 50),
            numberOfTaskView.widthAnchor.constraint(equalToConstant: 50),
        
            //Setups the constraints for push label
            pushLabel.topAnchor.constraint(equalTo: numberOfTaskView.bottomAnchor, constant: 30),
            pushLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
           
            //Setups the constraints for review label
            reviewLabel.topAnchor.constraint(equalTo: pushLabel.bottomAnchor, constant: 5),
            reviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
        
            //Setups the constraints for acceptance label
            acceptanceLabel.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 5),
            acceptanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            
            //Setups the constraints for push checkmark icon
            pushCheckmarkIcon.centerYAnchor.constraint(equalTo: pushLabel.centerYAnchor),
            pushCheckmarkIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightPadding),
            
            //Setups the constraints for push checkmark icon
            reviewCheckmarkIcon.centerYAnchor.constraint(equalTo: reviewLabel.centerYAnchor),
            reviewCheckmarkIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightPadding),
            
            //Setups the constraints for acceptance checkmark icon
            acceptanceCheckmarkIcon.centerYAnchor.constraint(equalTo: acceptanceLabel.centerYAnchor),
            acceptanceCheckmarkIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightPadding),
                        
        ])
    }
}
