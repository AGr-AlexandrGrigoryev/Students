//
//  StudentDetailButtons.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 14.03.2021.
//

import UIKit
import StoreKit

class StudentDetailButtons: UIButton {

    enum Buttons {
        case slack
        case email
        case linkedIn
    }
    
    var slackUrl: URL?
    let appStoreSlackUrl = URL(string: "itms-apps://apple.com/app/id618783545")
 
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    func setupButton(for button: Buttons, with url: URL?) {
        switch button {
        case .slack:
            slackUrl = url
            setupUI(title: "Slack", icon: "slack-1")
            addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        case .email:
            setupUI(title: "Email", icon: "email")
        case .linkedIn:
            setupUI(title: "LinkedIn", icon: "linkedin")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerVertically()
    }
    
    /// Set up button UI
    /// - Parameters:
    ///   - title: title of button
    ///   - icon: image for button
    func setupUI(title: String, icon: String) {
        guard let image = UIImage(named: icon) else { return }
        image.withRenderingMode(.alwaysTemplate)
        backgroundColor = UIColor.init(named: "ButtonsBackGroundColor") //a
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(UIColor(named: "ButtonImageColor"), for: .normal)
        setTitleColor(UIColor.label.withAlphaComponent(0.6), for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: 13)
        tintColor = UIColor(named: "ButtonImageColor")
        layer.cornerRadius = 25
    }
    
    /// Action for button
    @objc func didTapButton() {
        guard let url = slackUrl else { return }
        if UIApplication.shared.canOpenURL(url) {
            // deep link to student slack
            UIApplication.shared.open((url), options: [:], completionHandler: nil)
        } else {
            guard let url = appStoreSlackUrl else { return }
            UIApplication.shared.canOpenURL(url)
            // deep link to app store for slack
            UIApplication.shared.open((url), options: [:], completionHandler: nil)
        }
    }
}

extension UIButton {
    
    /// Center vertically text of buttons for social app.
    func centerVertically() {
        let spacing: CGFloat = 60
        titleEdgeInsets = UIEdgeInsets.init(top: imageView!.frame.size.height + spacing, left: -imageView!.frame.size.width, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -titleLabel!.frame.size.width)
    }
}
