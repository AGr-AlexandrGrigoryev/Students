//
//  TabBarVC.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 30.03.2021.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupTabBar() {
        UITabBar.appearance().tintColor = UIColor(named: "ButtonImageColor")
        
        let studentsVC = UINavigationController(rootViewController: StudentsVC())
        studentsVC.tabBarItem = UITabBarItem(title: "Účastníci", image: UIImage(systemName: "person.3.fill"), selectedImage: UIImage(systemName: "person.3.fill"))
        
        let accountVC = UINavigationController(rootViewController: AccountVC())
        accountVC.tabBarItem = UITabBarItem(title: "Účet", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
        
        viewControllers = [studentsVC, accountVC]
        
    }
}
