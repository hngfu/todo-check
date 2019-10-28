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

class ToDoListViewModel: ToDoViewModel {
    let dataSource: RxTableViewSectionedAnimatedDataSource<ToDoSectionModel> = {
        let dataSource = RxTableViewSectionedAnimatedDataSource<ToDoSectionModel> (configureCell: { dataSource, tableView, indexPath, todo in
            let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier,
                                                     for: indexPath)
            guard
                let toDoCell = cell as? ToDoTableViewCell
                else { return cell }
            toDoCell.set(with: todo)
            return cell
        })
        return dataSource
    }()
    
    var todoList: Observable<[ToDoSectionModel]> {
        return storage.toDoList()
    }
    
    lazy var createAction: Action<String, Void> = {
        return Action<String, Void> { content in
            self.storage.createToDo(content: content, completed: false)
            return Observable.empty()
        }
    }()
}
