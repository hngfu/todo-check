//
//  Scene.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/28.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

enum Scene {
    case toDoList(ToDoListViewModel)
    case completedToDoList(CompletedToDoListViewModel)
}

extension Scene {
    func instantiate(from storyboardName: String = "Main") -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        switch self {
            //MARK: To Do List
        case .toDoList(let viewModel):
            guard
                let nav = storyboard.instantiateViewController(withIdentifier: ToDoListViewController.identifierNavigation) as? UINavigationController,
                let toDoListVC = nav.topViewController as? ToDoListViewController
                else { return nil }
            
            toDoListVC.bind(viewModel: viewModel)
            return nav
            
            //MARK: Completed To Do List
        case .completedToDoList(let viewModel):
            guard
                let completedToDoListVC = storyboard.instantiateViewController(withIdentifier: CompletedToDoViewController.identifier) as? CompletedToDoViewController
                else { return nil }
            
            completedToDoListVC.bind(viewModel: viewModel)
            return completedToDoListVC
        }
    }
}
