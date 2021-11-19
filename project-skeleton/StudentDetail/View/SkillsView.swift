//
//  SkillsView.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 15.03.2021.
//

import UIKit

class SkillsView: UIView {
    
    private let platformImageView = UIImageView()
    private let skillRatingLabel = UILabel()
    
    private let noSkillsImage = UIImageView()
    
    private lazy var horizontalSkillProgressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.layer.cornerRadius = 6
        stackView.clipsToBounds = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
        
    init(platform: String, level: Int) {
        super.init(frame: .zero)
        setupProgressLevelUI(for: platform, for: level)
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
    
    func setupNoSkillsImage() {
        noSkillsImage.image = UIImage(named: "laptop_element")
        addSubview(noSkillsImage)
        noSkillsImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noSkillsImage.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            noSkillsImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            noSkillsImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            noSkillsImage.heightAnchor.constraint(equalToConstant: 145),
            noSkillsImage.widthAnchor.constraint(equalToConstant: 180),
        ])
    }
        
    private func platformAvatar (_ image: String) {
        
        platformImageView.image = UIImage(named: image)
        addSubview(platformImageView)
        
        platformImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            platformImageView.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            platformImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            platformImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            platformImageView.heightAnchor.constraint(equalToConstant: 30),
            platformImageView.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func skillProgressLevel(_ level: Int) {
        setupSkillProgressLevel(level)
        addSubview(horizontalSkillProgressStackView)
        
        horizontalSkillProgressStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           
            horizontalSkillProgressStackView.centerYAnchor.constraint(equalTo: platformImageView.centerYAnchor),
            horizontalSkillProgressStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            horizontalSkillProgressStackView.leadingAnchor.constraint(equalTo: platformImageView.trailingAnchor, constant: 20),
            horizontalSkillProgressStackView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
    }
    
    func setupSkillProgressLevel(_ level: Int) {
        for _ in 1...10 {
            
            while horizontalSkillProgressStackView.arrangedSubviews.count < 10 {
                let smallView = UIView()
                smallView.frame.size.height = 13
                smallView.frame.size.width = 13
                smallView.backgroundColor = .systemGray3
                horizontalSkillProgressStackView.addArrangedSubview(smallView)
            }
        }
        for view in 0..<level {
            UIView.animate(withDuration: 0.9) {
                self.horizontalSkillProgressStackView
                .subviews[view]
                .backgroundColor = UIColor(named: "LevelSkillLabelColor")
            }
        }
        
        //set gray color for skills from 10 to level of skills
        for view in level..<10 {
            UIView.animate(withDuration: 0.9) {
                self.horizontalSkillProgressStackView.subviews[view].backgroundColor = .systemGray3
            }
        }
    }
}
