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
    func toDoList(completed: Bool) -> Observable<[ToDoSectionModel]> {
        let listObservable: Observable<[ToDo]>
        if completed {
            listObservable = Observable.array(from: completedToDoStore)
        } else {
            listObservable = Observable.array(from: toDoStore)
        }
        return listObservable
            .map { toDoList -> [ToDoSectionModel] in
                return [ToDoSectionModel(model: 0, items: toDoList)]
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
