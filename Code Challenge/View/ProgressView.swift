//
//  ProgressView.swift
//  Code Challenge
//
//  Created by 230199M99806607 on 17/09/23.
//

import UIKit

class ProgressView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError(String(localized: "init_not_supported"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
    }
}
