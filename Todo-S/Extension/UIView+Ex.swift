//
//  UIView+Ex.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/23.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

extension UIView {
    func snapShotImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { (context) in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }
}
