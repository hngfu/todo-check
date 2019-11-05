//
//  RoundCornerTextField.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/21.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

@IBDesignable
class RoundCornerTextField: UITextField {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
