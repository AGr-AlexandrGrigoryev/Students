//
//  AccountLabels.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 13.04.2021.
//

import UIKit

class AccountLabels: UILabel {

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup name for logged user
    /// - Parameter name: name of user
    func setUpLoggedUserNameLabel2(with name: String) {
        text = name
        font = UIFont.systemFont(ofSize: 31, weight: .bold)
        numberOfLines = 0
    }
        
    // Set up label for profession in account screen
    /// - Parameter profession: profession of user
    func setUpLoggedUserProfessionLabel(with profession: String) {
        text = profession
        font = UIFont.systemFont(ofSize: 15, weight: .bold)
        numberOfLines = 0
        textColor = UIColor.systemGray
        textAlignment = .left
    }
    
    /// Set up skills label
    /// - Parameter skills: skill label
    func setupSkillsLabel(_ skills: String) {
        text = skills
        font = UIFont.systemFont(ofSize: 17, weight: .bold)
        numberOfLines = 0
        textColor = UIColor.systemGray
    }
    
    /// Set up rips label
    /// - Parameter tips: tips label
    func setupTipsLabel(_ skills: String) {
        text = skills
        font = UIFont.systemFont(ofSize: 15, weight: .bold)
        numberOfLines = 0
        textColor = UIColor.systemGray
    }
}
