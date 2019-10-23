//
//  TodoListViewModel.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/22.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa
import Action

class TodoListViewModel {
    private let storage: TodoStorageType! = RealmStorage()
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<TodoSectionModel> = {
        let dataSource = RxTableViewSectionedAnimatedDataSource<TodoSectionModel> (configureCell: { dataSource, tableView, indexPath, todo in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = todo.content
            return cell
        })
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        return dataSource
    }()
    
    var todoList: Observable<[TodoSectionModel]> {
        return storage.todoList()
    }
    
    lazy var createAction: Action<String, Void> = {
        return Action<String, Void> { content in
            self.storage.createTodo(content: content, completed: false)
            return Observable.empty()
        }
    }()
}
