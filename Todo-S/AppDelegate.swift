//
//  AppDelegate.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/21.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storage = RealmStorage()
        let coordinator = SceneCoordinator(window: window!)
        let viewModel = ToDoListViewModel(title: "할 일".localized,
                                          coordinator: coordinator,
                                          storage: storage!)
        let scene = Scene.toDoList(viewModel)
        coordinator.transition(to: scene, using: .root, animated: false)
        return true
    }
}

