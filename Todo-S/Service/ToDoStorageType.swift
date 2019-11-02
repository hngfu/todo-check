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
    func createToDo(content: String) -> Observable<ToDo>
    
    @discardableResult
    func toDoList(isCompleted: Bool) -> Observable<[ToDoSectionModel]>
    
    @discardableResult
    func complete(toDo: ToDo) -> Observable<ToDo>
    
    @discardableResult
    func moveToDo(at fromIndex: Int, to toIndex: Int, isCompleted: Bool) -> Observable<ToDo>
    
    @discardableResult
    func deleteAllCompleted() -> Completable
}
