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

typealias TodoSectionModel = AnimatableSectionModel<Int, Todo>

protocol TodoStorageType {
    @discardableResult
    func createTodo(content: String) -> Observable<Todo>
    
    @discardableResult
    func todoList() -> Observable<[TodoStorageType]>
    
    @discardableResult
    func delete(todo: Todo) -> Observable<Todo>
}
