//
//  RealmStorage.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/21.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

class RealmStorage: ToDoStorageType {
    private let realm: Realm
    
    private let toDos: List<ToDo>
    private var toDoSectionModel: ToDoSectionModel
    private let toDoStore: BehaviorSubject<[ToDoSectionModel]>
    
    private let completedToDos: List<ToDo>
    private var completedToDoSectionModel: ToDoSectionModel
    private let completedToDoStore: BehaviorSubject<[ToDoSectionModel]>
    
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
        self.toDoSectionModel = ToDoSectionModel(model: 0, items: self.toDos.toArray())
        self.toDoStore = BehaviorSubject<[ToDoSectionModel]>(value: [self.toDoSectionModel])
        self.completedToDos = toDoList.completedToDos
        self.completedToDoSectionModel = ToDoSectionModel(model: 0, items: self.completedToDos.toArray())
        self.completedToDoStore = BehaviorSubject<[ToDoSectionModel]>(value: [self.completedToDoSectionModel])
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
        toDoStore.onNext([toDoSectionModel])
        completedToDoSectionModel.items.insert(toDo, at: completedToDoSectionModel.items.count)
        completedToDoStore.onNext([completedToDoSectionModel])
        
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
    
    @discardableResult
    func deleteAllCompleted() -> Completable {
        let subject = PublishSubject<Void>()
        
        try? realm.write {
            completedToDoSectionModel.items.removeAll()
            completedToDoStore.onNext([completedToDoSectionModel])
            realm.delete(completedToDos)
        }
        
        return subject.ignoreElements()
    }
}
