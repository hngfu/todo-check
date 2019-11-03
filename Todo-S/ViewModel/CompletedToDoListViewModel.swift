//
//  CompletedToDoListViewModel.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/28.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

class CompletedToDoListViewModel: ToDoViewModel {
    lazy var dataSource: RxTableViewSectionedAnimatedDataSource<ToDoSectionModel> = {
        let dataSource = RxTableViewSectionedAnimatedDataSource<ToDoSectionModel> (configureCell: { dataSource, tableView, indexPath, toDo in
            let cell = UITableViewCell()
            cell.textLabel?.text = toDo.content
            return cell
        })
        dataSource.animationConfiguration = .init(insertAnimation: .fade,
                                                  reloadAnimation: .automatic,
                                                  deleteAnimation: .right)
        return dataSource
    }()
    
    var toDoList: Observable<[ToDoSectionModel]> {
        return storage.toDoList(isCompleted: true)
    }
    
    func deleteAllCompletedToDo() {
        self.storage.deleteAllCompleted()
    }
}
