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
    private let toDos: List<ToDo>
    private lazy var toDoSectionModel = ToDoSectionModel(model: 0, items: self.toDos.toArray())
    private lazy var toDoStore = BehaviorSubject<[ToDoSectionModel]>(value: [self.toDoSectionModel])
    private let completedToDos: List<ToDo>
    private lazy var completedToDoSectionModel = ToDoSectionModel(model: 0, items: self.completedToDos.toArray())
    private lazy var completedToDoStore = BehaviorSubject<[ToDoSectionModel]>(value: [self.completedToDoSectionModel])
    
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
        
        self.toDos = toDoList.toDos
        self.completedToDos = toDoList.completedToDos
    }
    
    @discardableResult
    func createToDo(content: String) -> Observable<ToDo> {
        let toDo = ToDo()
        toDo.content = content
        
        try? realm.write {
            toDos.insert(toDo, at: toDos.count)
        }
        
        toDoSectionModel.items.insert(toDo, at: toDoSectionModel.items.count)
        toDoStore.onNext([toDoSectionModel])

        return Observable.just(toDo)
    }
    
    @discardableResult
    func toDoList(isCompleted: Bool = false) -> Observable<[ToDoSectionModel]> {
        return isCompleted ? completedToDoStore : toDoStore
    }
    
    @discardableResult
    func complete(toDo: ToDo) -> Observable<ToDo> {
        guard
            let index = toDos.index(of: toDo)
            else { return Observable.just(toDo) }
        
        try? realm.write {
            toDos.remove(at: index)
            completedToDos.insert(toDo, at: completedToDos.count)
        }
        toDoSectionModel.items.remove(at: index)
        completedToDoSectionModel.items.insert(toDo, at: completedToDoSectionModel.items.count)
        toDoStore.onNext([toDoSectionModel])
        
        return Observable.just(toDo)
    }

    @discardableResult
    func moveToDo(at fromIndex: Int, to toIndex: Int, isCompleted: Bool = false) -> Observable<ToDo> {
        let list = isCompleted ? completedToDos : toDos
        let toDo = list[fromIndex]
        try? realm.write {
            list.move(from: fromIndex, to: toIndex)
        }
        return Observable.just(toDo)
    }
}
