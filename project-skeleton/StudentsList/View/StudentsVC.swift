//
//  StudentsViewController.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 22.03.2021.
//

import UIKit
import Combine
import LocalAuthentication

class StudentsVC: UIViewController {
    
    // MARK: - Properties
    private var bag = Set<AnyCancellable>()
    private let viewModel = StudentListVM()
    private let loginViewModel = LoginVM()
    public let tableView = UITableView(frame: .zero, style: .grouped)
    private let rowHeighForTableView: CGFloat = 80
    private var dataSource: StudentsDataSource?
    private var segmentedControl = UISegmentedControl(items: ["All", "iOS", "Android"])
    private let noDataLabel = NoDataLabel()
    let loginVC = LoginVC()
    
    let blurView = UIView()
    
    private lazy var tryAgainButton: TryAgainButton  = {
        let button = TryAgainButton(type: .system)
        button.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Live cycle of view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupUI()
        render()
        setupBindings()
        view.applyBlurEffect()
        authenticateUser()
        loginVC.listViewModel = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadStudentsList()
        tableView.reloadData()
        print("view will appear")
    }
    
    
    // MARK: - Functions
    private func setupDataSource() {
        tableView.register(StudentCellView.self, forCellReuseIdentifier: StudentCellView.identifier)
        
        // UITableViewDataSource Implementation
        dataSource = StudentsDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, content) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: StudentCellView.identifier, for: indexPath) as? StudentCellView
            cell?.customize(with: content)
            cell?.didSelect = {
                self.navigationController?.pushViewController(StudentDetailVC(studentId: content.id, title: content.name), animated: true)
            }
            return cell
        })
    }
    
    /// Setup UI for this view controller
    private func setupUI() {
        navigationItem.title = "EMA 21"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl
            .publisher(for: \.selectedSegmentIndex)
            .sink { [weak self] index in
                self?.viewModel.filter.send(index)
            }
            .store(in: &bag)
        
        tableView.rowHeight = rowHeighForTableView
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = .systemBackground
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func render() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned  self] (state) in
                switch state {
                case .authorized:
                    setupBindings()
                    print("### authorized")
                case .unauthorized:
                    print("### unauthorized user try again")
                    // if userDefaults does not have userId or password, show Login form
                    guard let userName = Auth.userDefaults.userId,
                          let password = Auth.userDefaults.password else {
                        viewModel.statePublisher.send(StateOfNetworking.loggedOut)
                        return
                    }
                    /*
                    If token is not valid, status is unauthorized. Then we try to login one more.
                    in login method we fetchAccessToken one  more with userName and password
                    */
                    loginViewModel.login(userName: userName , password: password)
                    viewModel.loadStudentsList()
                case .isLoading:
                    print("### isLoading...")
                    tableView.isHidden = true
                    view.showLoading()
                case .error(let error):
                    print("### Error is \(error)")
                    tableView.removeFromSuperview()
                    appearRefreshButton()
                    view.stopLoading()
                case .loaded:
                    print("### loaded")
                    tableView.isHidden = false
                    view.stopLoading()
                    case .loggedOut:
                        present(loginVC, animated: true)
                        view.removeBlurEffect()
                        print("### loggedOut")
                }
            }
            .store(in: &bag)
    }
    
    func setupBindings() {
        viewModel.students
            .receive(on: DispatchQueue.main)
            .print("debag")
            .sink(receiveValue: { [weak self] (students) in
                self?.applySnapshot(with: students)
            })
            .store(in: &bag)
    }
    
    /// Refresh data if something happened
    @objc func refreshData() {
        tryAgainButton.removeFromSuperview()
        noDataLabel.removeFromSuperview()
        viewModel.loadStudentsList()
        view.addSubview(tableView)
        setupConstraints()
        
    }
    
    /// Provide data for  table views
    /// - Parameter students: student's content
    private func applySnapshot(with students: [StudentCellView.Content]?) {
        // Create a snapshot
        var snapshot =  NSDiffableDataSourceSnapshot<StudentsSection, StudentCellView.Content>()
        // Populate the snapshot
        snapshot.appendSections([.fistSection])
        guard let students = students else { return }
        snapshot.appendItems(students)
        // Apply the snapshot
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


extension StudentsVC {
    // MARK: - Layout Handling
    private func appearRefreshButton () {
        [tryAgainButton,noDataLabel].forEach{view.addSubview($0)}
        [tryAgainButton,noDataLabel].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            // Constrains for no data label
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Constrains for try again button
            tryAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tryAgainButton.topAnchor.constraint(equalTo: noDataLabel.bottomAnchor, constant: 20),
        ])
    }
    
    private func setupConstraints() {
        [tableView,segmentedControl].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            // Constrains for segmented control
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            // Constrains for segmented table view
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


