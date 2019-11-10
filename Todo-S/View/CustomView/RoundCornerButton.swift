//
//  RoundCornerButton.swift
//  ToDo S
//
//  Created by 조재흥 on 2019/11/10.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

@IBDesignable
class RoundCornerButton: UIButton {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}
