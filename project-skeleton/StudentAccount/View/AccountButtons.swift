//
//  AccountButtons.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 13.04.2021.
//

import UIKit

class AccountButtons: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func setupStepper() -> UIStepper {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }
    
    func setupLogOutButton(for button: UIButton) {
        button.setImage(UIImage(named: "log out"), for: .normal)
    }
    
    func setupEditSkillsButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "edit skills"), for: .normal)
        return button
    }
}
