//
//  TodoList.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/22.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoList: Object {
    let toDos = List<ToDo>()
}
