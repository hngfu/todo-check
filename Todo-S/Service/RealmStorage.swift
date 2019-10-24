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

class RealmStorage: ToDoStorageType {
    private let realm: Realm
    private let store: List<ToDo>
    
    init?() {
        guard
            let realm = try? Realm()
            else { return nil }
        
        self.realm = realm
        if realm.objects(ToDoList.self).count == 0 {
            try? realm.write {
                let toDoList = ToDoList()
                realm.add(toDoList)
            }
        }
        print(Realm.Configuration.defaultConfiguration.fileURL)
        guard
            let store = realm.objects(ToDoList.self).first?.toDos
            else { return nil }
        
        self.store = store
    }
    
    @discardableResult
    func createToDo(content: String, completed: Bool = false) -> Observable<ToDo> {
        let toDo = ToDo()
        toDo.content = content
        toDo.isCompleted = completed
        
        try? realm.write {
            if completed {
                store.insert(toDo, at: store.count)
            } else {
                let countNotCompletedTodo = store.filter("isCompleted = false").count
                store.insert(toDo, at: countNotCompletedTodo)
            }
        }
        
        return Observable.just(toDo)
    }
    
    @discardableResult
    func toDoList() -> Observable<[ToDoSectionModel]> {
        Observable.array(from: store)
            .map { (toDos) -> [ToDoSectionModel] in
                let notCompletedToDos = toDos.filter { $0.isCompleted == false }
                let completedToDos = toDos.filter { $0.isCompleted == true }
                return [
                    ToDoSectionModel(model: "To Do", items: notCompletedToDos),
                    ToDoSectionModel(model: "Completed", items: completedToDos)
                ]
        }
    }
    
    @discardableResult
    func delete(toDo: ToDo) -> Observable<ToDo> {
        
        try? realm.write {
            realm.delete(toDo)
        }
        
        return Observable.just(toDo)
    }
}
