//
//  String+Ex.swift
//  ToDo S
//
//  Created by 조재흥 on 2019/11/13.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
