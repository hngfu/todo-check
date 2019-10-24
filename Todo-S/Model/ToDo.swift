//
//  Todo.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/21.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class ToDo: Object, IdentifiableType {
    @objc dynamic var content: String = ""
    @objc dynamic var identity: String = "\(Date().timeIntervalSinceReferenceDate)"
}
