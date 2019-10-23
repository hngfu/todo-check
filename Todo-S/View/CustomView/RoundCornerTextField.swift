//
//  RoundCornerTextField.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/21.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit


class RoundCornerTextField: UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = self.layer.bounds.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
