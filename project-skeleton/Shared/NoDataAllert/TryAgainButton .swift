//
//  TryAgainButton .swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 06.04.2021.
//

import UIKit

class TryAgainButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Zkusit znovu", for: .normal)
        contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        backgroundColor = UIColor(named: "LevelSkillLabelColor")
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
