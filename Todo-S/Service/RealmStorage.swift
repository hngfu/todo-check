//
//  RealmStorage.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/21.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import RxRealm

class RealmStorage: TodoStorageType {
    private let realm: Realm
    private let store: List<Todo>
    
    init?() {
        guard
            let realm = try? Realm()
            else { return nil }
        
        self.realm = realm
        if realm.objects(TodoList.self).count == 0 {
            try? realm.write {
                let todoList = TodoList()
                realm.add(todoList)
            }
        }
        
        guard
            let store = realm.objects(TodoList.self).first?.todos
            else { return nil }
        
        self.store = store
    }
    
    @discardableResult
    func createTodo(content: String, completed: Bool = false) -> Observable<Todo> {
        let todo = Todo()
        todo.content = content
        todo.isCompleted = completed
        
        try? realm.write {
            if completed {
                store.insert(todo, at: store.count)
            } else {
                let countNotCompletedTodo = store.filter("isCompleted = false").count
                store.insert(todo, at: countNotCompletedTodo)
            }
        }
        
        return Observable.just(todo)
    }
    
    @discardableResult
    func todoList() -> Observable<[TodoSectionModel]> {
        Observable.array(from: store)
            .map { (todos) -> [TodoSectionModel] in
                let notCompletedTodos = todos.filter { $0.isCompleted == false }
                let completedTodos = todos.filter { $0.isCompleted == true }
                return [
                    TodoSectionModel(model: 0, items: notCompletedTodos),
                    TodoSectionModel(model: 1, items: completedTodos)
                ]
        }
    }
    
    @discardableResult
    func delete(todo: Todo) -> Observable<Todo> {
        
        try? realm.write {
            realm.delete(todo)
        }
        
        return Observable.just(todo)
    }
}
