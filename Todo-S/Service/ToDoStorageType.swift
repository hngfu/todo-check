//
//  TodoStorageType.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/21.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

typealias ToDoSectionModel = AnimatableSectionModel<Int, ToDo>

protocol ToDoStorageType {
    @discardableResult
    func createToDo(content: String, completed: Bool) -> Observable<ToDo>
    
    @discardableResult
    func toDoList(completed: Bool) -> Observable<[ToDoSectionModel]>
    
    @discardableResult
    func delete(toDo: ToDo) -> Observable<ToDo>
    
    @discardableResult
    func moveToDo(at fromIndex: Int, to toIndex: Int, completed: Bool) -> Observable<ToDo>
}
