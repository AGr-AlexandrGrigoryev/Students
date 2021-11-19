//
//  StudentDetailImage.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 14.03.2021.
//

import UIKit
import SDWebImage

class StudentDetailImage: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCornerRadius()
    }
    
    /// Set up image for picture of user
    /// - Parameter image: image for user
    func setupUI2(for image: URL) {
        sd_setImage(with: image) { [weak self] (_, _, _, _) in
            self?.setNeedsLayout()
        }
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.masksToBounds = true
    }
    
    /// Set up rounded image of user
    private func setupCornerRadius() {
        layer.cornerRadius = frame.size.height / 2
    }
    
}
