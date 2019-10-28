//
//  ViewModel.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/28.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ToDoViewModel {
    let title: Driver<String>
    let coordinator: CoordinatorType
    let storage: ToDoStorageType
    
    init(title: String, coordinator: CoordinatorType, storage: ToDoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.coordinator = coordinator
        self.storage = storage
    }
}
