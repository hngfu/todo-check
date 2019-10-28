//
//  UIViewController+Ex.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/28.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

extension UIViewController {
    func sceneViewController() -> UIViewController {
        return self.children.first ?? self
    }
}
