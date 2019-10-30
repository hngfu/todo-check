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
        dataSource.decideViewTransition = { (_, _, change) in
            let isMoved = change[1].movedItems.count > 0
            if isMoved {
                return .reload
            }
            return .animated
        }
        return dataSource
    }()
    
    var toDoList: Observable<[ToDoSectionModel]> {
        return storage.toDoList(completed: false)
    }
    
    lazy var createAction: Action<String, Void> = {
        return Action<String, Void> { content in
            self.storage.createToDo(content: content, completed: false)
            return Observable.empty()
        }
    }()
    
    func moveToDo(at fromIndex: Int, to toIndex: Int) {
        self.storage.moveToDo(at: fromIndex, to: toIndex, completed: false)
    }
}
