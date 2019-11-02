//
//  CompletedToDoViewController.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/28.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CompletedToDoViewController: UIViewController, ViewModelBindableType {

    static let identifier = "CompletedToDoListViewController"
    
    @IBOutlet weak var completedToDoListTableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var viewModel: CompletedToDoListViewModel!
    private let disposeBag = DisposeBag()
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.toDoList
            .bind(to: completedToDoListTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap.asDriver()
            .drive(onNext: {
                let alert = UIAlertController(title: nil, message: nil,
                                              preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                var deleteAction = UIAlertAction(title: "완료된 To Do 모두 삭제", style: .destructive)
                deleteAction.rx.action = self.viewModel.makeDeleteAction()
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
