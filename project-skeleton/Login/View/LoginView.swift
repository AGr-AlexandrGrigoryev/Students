//
//  LoginView.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 12.04.2021.
//

import UIKit

class LoginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextField(for field: UITextField, with text: String, secure: Bool ) {
        field.placeholder = text
        field.tintColor = .orange
        field.textAlignment = .left
        field.keyboardType = .asciiCapable
        field.returnKeyType = .done
        field.isSecureTextEntry = secure
        field.layer.borderColor = UIColor(named: "Login Button")?.cgColor
        field.layer.borderWidth = 0.5
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 10
        field.setLeftPaddingPoints(10)
    }
    
    func setupLoginButton(button: UIButton) {
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.contentEdgeInsets = .init(top: 10, left: 20, bottom: 10, right: 20)
        button.backgroundColor = UIColor(named: "Login Button")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        setupShadowFor(button)    
    }
    
    /// Set up description  label
    /// - Parameter textLabel: text
    func setupDescriptionLabel(_ textLabel: String) -> UILabel {
        let label = UILabel()
        label.text = textLabel
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor.systemGray
        return label
    }
    
    /// Set up description  label
    /// - Parameter textLabel: text
    func setupDescriptionIdLabel() -> UILabel {
        let label = UILabel()
        label.text = """
                     If you don't have ID
                     Please contact our development team
                     """
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.numberOfLines = 2
        label.textColor = UIColor.systemGray
        label.textAlignment = .center
        return label
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
