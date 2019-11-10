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
           let cell = tableView.dequeueReusableCell(withIdentifier: CompletedToDoTableViewCell.identifier,
                                                     for: indexPath)
            guard
                let completedToDoCell = cell as? CompletedToDoTableViewCell
                else { return cell }
            completedToDoCell.set(with: toDo)
            let isEvenIndex = indexPath.row.isMultiple(of: 2)
            completedToDoCell.setColor(isEvenIndex: isEvenIndex)
            return completedToDoCell
        })
        dataSource.animationConfiguration = .init(insertAnimation: .left,
                                                  reloadAnimation: .automatic,
                                                  deleteAnimation: .fade)
        return dataSource
    }()
    
    var toDoList: Observable<[ToDoSectionModel]> {
        return storage.toDoList(isCompleted: true)
    }
    
    func deleteAllCompletedToDo() {
        self.storage.deleteAllCompleted()
    }
}
