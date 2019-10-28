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
    private let toDoStore: List<ToDo>
    private let completedToDoStore: List<ToDo>
    
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

        guard
            let toDoList = realm.objects(ToDoList.self).first
            else { return nil }
        
        self.toDoStore = toDoList.toDos
        self.completedToDoStore = toDoList.completedToDos
    }
    
    @discardableResult
    func createToDo(content: String, completed: Bool = false) -> Observable<ToDo> {
        let toDo = ToDo()
        toDo.content = content
        
        try? realm.write {
            if completed {
                completedToDoStore.insert(toDo, at: completedToDoStore.count)
            } else {
                toDoStore.insert(toDo, at: toDoStore.count)
            }
        }
        
        return Observable.just(toDo)
    }
    
    @discardableResult
    func toDoList() -> Observable<[ToDoSectionModel]> {
        let toDoObservable = Observable.array(from: toDoStore)
        let completedToDoObservable = Observable.array(from: completedToDoStore)
        return Observable.combineLatest(toDoObservable, completedToDoObservable)
            .map { allToDo -> [ToDoSectionModel] in
                let (toDos, completedToDos) = allToDo
                return [ToDoSectionModel(model: 0, items: toDos)]
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
