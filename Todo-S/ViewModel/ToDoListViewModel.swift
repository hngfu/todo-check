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
    lazy var dataSource: RxTableViewSectionedAnimatedDataSource<ToDoSectionModel> = {
        let dataSource = RxTableViewSectionedAnimatedDataSource<ToDoSectionModel> (configureCell: { dataSource, tableView, indexPath, toDo in
            let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier,
                                                     for: indexPath)
            guard
                let toDoCell = cell as? ToDoTableViewCell
                else { return cell }
            toDoCell.set(with: toDo)
            toDoCell.checkButton.rx.action = self.makeCompleteAction(toDo: toDo)
            return cell
        })
        dataSource.animationConfiguration = .init(insertAnimation: .fade,
                                                  reloadAnimation: .automatic,
                                                  deleteAnimation: .right)
        return dataSource
    }()
    
    var toDoList: Observable<[ToDoSectionModel]> {
        return storage.toDoList(isCompleted: false)
    }
    
    lazy var createAction: Action<String, Void> = {
        return Action<String, Void> { content in
            self.storage.createToDo(content: content)
            return Observable.empty()
        }
    }()
    
    func moveToDo(at fromIndex: Int, to toIndex: Int) {
        self.storage.moveToDo(at: fromIndex, to: toIndex, isCompleted: false)
    }
    
    private func makeCompleteAction(toDo: ToDo) -> CocoaAction {
        return CocoaAction {
            self.storage.complete(toDo: toDo)
            return Observable.empty()
        }
    }
}
