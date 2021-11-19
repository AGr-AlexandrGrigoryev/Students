//
//  NoDataLabel.swift
//  project-skeleton
//
//  Created by Alexandr Grigoryev on 06.04.2021.
//

import UIKit

class NoDataLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        text = "No data"
        font = UIFont.systemFont(ofSize: 17, weight: .light)
        numberOfLines = 0
        textColor = .label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
