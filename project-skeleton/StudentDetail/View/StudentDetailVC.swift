//
//  StudentDetailVC.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 15.03.2021.
//

import UIKit
import Combine

class StudentDetailVC: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    public var id: String
    private var nameTitle: String
    
    //MARK: - View for view controller
    private let scrollView = UIScrollView()
    public var contentView = StudentDetailView()
    private let noDataLabel = NoDataLabel()
    private let loginVM = LoginVM()
    
    private lazy var tryAgainButton: TryAgainButton  = {
        let button = TryAgainButton(type: .system)
        button.addTarget(self, action: #selector(refreshDataButtonAction), for: .touchUpInside)
        return button
    }()
    
    init(studentId: String, title: String ) {
        self.id = studentId
        self.nameTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Live cycle of view controller
    override func viewDidLoad() {
        print("###\(id)")
        self.navigationItem.title = nameTitle
        setupUI()
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        contentView.bcViewModel.loadStudent(by: id)
        super.viewWillAppear(animated)
    }
    
    /// Set up user interface for view controller
    private func setupUI() {
        self.view.backgroundColor = .systemGroupedBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        setupConstraints()
    }
    
    private func render() {
        contentView.bcViewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (state) in
                switch state {
                case .isLoading:
                    print("### isLoading...")
                    self?.contentView.isHidden = true
                    self?.view.showLoading()
                case .error(let error):
                    print("### Error is \(error)")
                    self?.contentView.removeFromSuperview()
                    // refresh button appears, after clicking on button data reloads
                    self?.appearRefreshButton()
                    self?.view.stopLoading()
                case .loaded:
                    print("### loaded")
                    self?.contentView.isHidden = false
                    self?.view.stopLoading()
                case .authorized:
                    print("### authorized")
                case .unauthorized:
                    print("### unauthorized")
                    guard let userId = Auth.userDefaults.userId,
                          let password = Auth.userDefaults.password else { return }
                    self?.loginVM.login(userName: userId , password: password)
                    self?.contentView.bcViewModel.loadStudent(by: userId)
                case .loggedOut:
                    print("### loggedOut")
                }
            }
            .store(in: &bag)
    }
        
    @objc func refreshDataButtonAction() {
        tryAgainButton.removeFromSuperview()
        noDataLabel.removeFromSuperview()
        contentView.bcViewModel.loadStudent(by: id)
        setupUI()
        setupConstraints()
    }
}

extension StudentDetailVC {
    
    private func appearRefreshButton () {
        [tryAgainButton,noDataLabel].forEach{view.addSubview($0)}
        [tryAgainButton,noDataLabel].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tryAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tryAgainButton.topAnchor.constraint(equalTo: noDataLabel.bottomAnchor, constant: 20),
        ])
    }
    
    /// Set up constrains for view's container and  scrollview
    private func setupConstraints() {
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        
        [scrollView, contentView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frameGuide.topAnchor.constraint(equalTo: view.topAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            frameGuide.widthAnchor.constraint(equalTo: contentGuide.widthAnchor)
        ])
    }
}
