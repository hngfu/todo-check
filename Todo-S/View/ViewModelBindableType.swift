//
//  ViewModelBindableType.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/28.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

protocol ViewModelBindableType where Self: UIViewController {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension ViewModelBindableType {
    func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
