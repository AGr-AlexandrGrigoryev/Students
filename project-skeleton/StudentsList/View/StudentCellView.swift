//
//  StudentCellView.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 22.03.2021.
//

import UIKit
import SDWebImage

class StudentCellView: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "StudentCellViewIdentifier"
    var didSelect: (() -> Void)?
    var views = [UIView]()
    private let name = UILabel()
    private var studentImage = UIImageView()
    private var studentPlatformLogo = UIImageView()
    private let numberOfTaskView = UIView()
    
    private lazy var horizontalHomeWorkProgressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCornerRadius()
    }
    
    // MARK: - Functions
    
    /// Setup homework progress, depends on the count of homework
    /// - Parameter homework: count of homework
    func setupHomeWorkProgress(with homework: Int) {
        for number in 1...homework {
            
            let label = UILabel()
            label.text = "\(number)"
            label.font = .systemFont(ofSize: 12, weight: .heavy)
            label.textColor = UIColor(named: "TasksNumberColor")
            label.numberOfLines = 0
            
            let smallView = UIView()
            smallView.backgroundColor = .secondarySystemBackground
            smallView.heightAnchor.constraint(equalToConstant: 25).isActive = true
            smallView.widthAnchor.constraint(equalToConstant: 25).isActive = true
            smallView.clipsToBounds = true
            smallView.layer.cornerRadius =  12.5
            smallView.backgroundColor = UIColor.systemGray5
            smallView.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerYAnchor.constraint(equalTo: smallView.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: smallView.centerXAnchor).isActive = true
            
            views.append(smallView)
        }
    }
    
    // MARK: - Content
    func setupContent() {
        name.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        name.numberOfLines = 0
        name.textColor = UIColor.systemGray
        
        studentImage.contentMode = .scaleAspectFill
        studentImage.clipsToBounds = true
        studentImage.layer.masksToBounds = true
        
        contentView.addSubview(name)
        contentView.addSubview(studentImage)
        contentView.addSubview(horizontalHomeWorkProgressStackView)
        contentView.addSubview(studentPlatformLogo)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        studentImage.translatesAutoresizingMaskIntoConstraints = false
        horizontalHomeWorkProgressStackView.translatesAutoresizingMaskIntoConstraints = false
        studentPlatformLogo.translatesAutoresizingMaskIntoConstraints = false
        
        // add reaction on tap to row in table view
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    
        NSLayoutConstraint.activate([
            
            // Constrains for student image
            studentImage.heightAnchor.constraint(equalToConstant: 55),
            studentImage.widthAnchor.constraint(equalToConstant: 55),
            studentImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            studentImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Constrains for student platform logo
            studentPlatformLogo.centerXAnchor.constraint(equalTo: studentImage.trailingAnchor, constant: -5),
            studentPlatformLogo.centerYAnchor.constraint(equalTo: studentImage.bottomAnchor, constant: -5),
            studentPlatformLogo.heightAnchor.constraint(equalToConstant: 30),
            studentPlatformLogo.widthAnchor.constraint(equalToConstant: 30),
            
            // Constrains for student name
            name.topAnchor.constraint(equalTo: studentImage.topAnchor),
            name.leadingAnchor.constraint(equalTo: studentImage.trailingAnchor, constant: 30),
            
            // Constrains for stack view
            horizontalHomeWorkProgressStackView.bottomAnchor.constraint(equalTo: studentImage.bottomAnchor),
            horizontalHomeWorkProgressStackView.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            horizontalHomeWorkProgressStackView.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    // MARK: - Actions
    @objc
    private func didTap() {
        didSelect?()
    }
    
    /// Set up rounded image of user
    private func setupCornerRadius() {
        studentImage.layer.cornerRadius = studentImage.frame.size.height / 2
        studentPlatformLogo.layer.cornerRadius = studentPlatformLogo.frame.size.height / 2
        
        studentPlatformLogo.clipsToBounds = true
        studentPlatformLogo.layer.masksToBounds = true
        
        studentPlatformLogo.layer.borderWidth = 2
        studentPlatformLogo.layer.borderColor = UIColor.systemBackground.cgColor
    }
    
    // MARK: - Customization
    
    /// Customize cell with content
    /// - Parameter content: content of student
    func customize(with content: Content ) {
        // Set name for user
        name.text = content.name
        
        // Set image for user
        studentImage.sd_setImage(with: content.icon192) { [weak self] (_, _, _, _) in
            self?.setNeedsLayout()
        }
        
        // Setup platform logo depends on student type
        switch content.participantType {
        case .iosStudent:
            studentPlatformLogo
                .image = UIImage(named: "iosStudent")
        case .androidStudent:
            studentPlatformLogo
                .image = UIImage(named: "androidStudent")
        default:
            break
        }
        
        // Setup progress with homework count
        setupHomeWorkProgress(with: content.homework.count )
        _ = content.homework.map { (work) in
            if work.state.rawValue == State.acceptance.rawValue {
                horizontalHomeWorkProgressStackView.subviews[work.number - 1].backgroundColor = UIColor(named: "TasksColor")
            } else {
                horizontalHomeWorkProgressStackView.subviews[work.number - 1].backgroundColor = UIColor.systemGray5
            }
        }
        setupContent()
    }
}

// MARK: - Extension
extension StudentCellView {
    struct Content: Hashable, Equatable {
        let id: String
        let name: String
        let participantType: ParticipantType
        let icon192: URL
        let homework: [HomeWork]
    }
}

