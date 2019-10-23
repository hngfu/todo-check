//
//  TodoListViewController.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/21.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import RxOptional

class TodoListViewController: UIViewController {
    
    @IBOutlet weak var todoListTableView: UITableView!
    @IBOutlet weak var inputTextField: RoundCornerTextField!
    @IBOutlet weak var inputContainerViewBottomConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    private let viewModel = TodoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.becomeFirstResponder()
        todoListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        bind()
    }
    
    func bind() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                guard let `self` = self else { return }
                let height = height - self.view.safeAreaInsets.bottom
                UIView.animate(withDuration: 0) {
                    self.inputContainerViewBottomConstraint.constant = max(height, 0)
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.todoList
            .bind(to: todoListTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        inputTextField.rx.shouldReturn
            .withLatestFrom(inputTextField.rx.text)
            .filterNil()
            .bind(to: viewModel.createAction.inputs)
            .disposed(by: disposeBag)
    }
}
