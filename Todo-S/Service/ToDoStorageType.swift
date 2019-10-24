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

typealias ToDoSectionModel = AnimatableSectionModel<String, ToDo>

protocol ToDoStorageType {
    @discardableResult
    func createToDo(content: String, completed: Bool) -> Observable<ToDo>
    
    @discardableResult
    func toDoList() -> Observable<[ToDoSectionModel]>
    
    @discardableResult
    func delete(toDo: ToDo) -> Observable<ToDo>
}
