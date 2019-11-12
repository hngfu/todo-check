//
//  RoundCornerView.swift
//  ToDo S
//
//  Created by 조재흥 on 2019/11/12.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

@IBDesignable
class RoundCornerView: UIView {

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
     }
}
