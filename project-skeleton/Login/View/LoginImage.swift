//
//  LoginImage.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 29.04.2021.
//

import UIKit

class LoginImage: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// Set up image for picture
    /// - Parameter image: image for login screen
    func setupImage() {
        self.image = UIImage(named: "Login image")
        contentMode = .center
        setNeedsLayout()
        setupShadowFor(self)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.masksToBounds = true
    }
    
    /// Set up rounded image of user
    private func setupCornerRadius() {
        layer.cornerRadius = frame.size.height / 2
    }
    
}

