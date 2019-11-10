//
//  DashedLineView.swift
//  ToDo S
//
//  Created by 조재흥 on 2019/11/10.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

class DashedLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let dashedLineLayer = CAShapeLayer()
        dashedLineLayer.strokeColor = UIColor.white.cgColor
        dashedLineLayer.lineWidth = 2.5
        dashedLineLayer.lineDashPattern = [9]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: self.bounds.height / 2),
                                CGPoint(x: self.bounds.width, y: self.bounds.height / 2)])
        dashedLineLayer.path = path
        
        self.layer.addSublayer(dashedLineLayer)
    }
}
