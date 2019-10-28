//
//  CompletedToDoViewController.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/28.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

class CompletedToDoViewController: UIViewController, ViewModelBindableType {

    static let identifier = "CompletedToDoListViewController"
    
    var viewModel: CompletedToDoListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        
    }
}
