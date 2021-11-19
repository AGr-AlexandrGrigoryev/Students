//
//  StudentDetailLabels.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 14.03.2021.
//

import UIKit

class StudentDetailLabels: UILabel {
   
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    init(_ skills: String) {
        super.init(frame: .zero)
        setupSkillsLabel(skills)
    }
    
    init(tasks: String) {
        super.init(frame: .zero)
        setupHomeWorkLabel(tasks)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup name for business card's user
    /// - Parameter name: name of user
    func setUpNameLabel2(for name: String) {
        text = name
        font = UIFont.systemFont(ofSize: 35, weight: .bold)
        numberOfLines = 0
    }
    
    // Set up label for profession
    /// - Parameter profession: profession of user
    func setUpProfessionLabel2(for profession: String) {
        text = profession
        font = UIFont.systemFont(ofSize: 15, weight: .bold)
        numberOfLines = 0
        textColor = UIColor.systemGray
        textAlignment = .center
    }
    
    /// Set up skills label
    /// - Parameter skills: skill label
    private func setupSkillsLabel(_ skills: String) {
        text = skills
        font = UIFont.systemFont(ofSize: 17, weight: .bold)
        numberOfLines = 0
        textColor = UIColor.systemGray
    }
    
    /// Set up home work label
    /// - Parameter skills: home work label
    private func setupHomeWorkLabel(_ label: String) {
        text = label
        font = UIFont.systemFont(ofSize: 17, weight: .bold)
        numberOfLines = 0
        textColor = UIColor.systemGray
    }
}
