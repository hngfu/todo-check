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
import SnapKit

class CompletedToDoViewController: UIViewController, ViewModelBindableType {

    static let identifier = "CompletedToDoListViewController"
    
    @IBOutlet weak var completedToDoListTableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var viewModel: CompletedToDoListViewModel!
    private let disposeBag = DisposeBag()
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.toDoList
            .bind(to: completedToDoListTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: {
                let alert = UIAlertController(title: nil, message: "완료된 To Do들이 모두 삭제됩니다.", preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let deleteAction = UIAlertAction(title: "모두 삭제", style: .destructive, handler: { _ in self.viewModel.deleteAllCompletedToDo() })
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .filter({ _ -> Bool in
                let hasCell = self.completedToDoListTableView.numberOfRows(inSection: 0) > 0
                return hasCell ? true : false
            })
            .subscribe(onNext: {
                guard
                    let img = self.contentImage()
                    else { return }
                let vc = UIActivityViewController(activityItems: [img], applicationActivities: nil)
                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func contentImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(completedToDoListTableView.contentSize, false, UIScreen.main.scale)
        let savedContentOffset = completedToDoListTableView.contentOffset
        completedToDoListTableView.showsVerticalScrollIndicator = false

        let contentRect = CGRect(origin: .zero, size: completedToDoListTableView.contentSize)
        completedToDoListTableView.frame = contentRect
        
        let tmpView = UIView(frame: contentRect)
        completedToDoListTableView.removeFromSuperview()
        tmpView.addSubview(completedToDoListTableView)
        guard
            let context = UIGraphicsGetCurrentContext()
            else { return nil }
        tmpView.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        tmpView.removeFromSuperview()
        self.view.addSubview(completedToDoListTableView)

        completedToDoListTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(toolBar.snp.top)
        }
        completedToDoListTableView.contentOffset = savedContentOffset
        completedToDoListTableView.showsVerticalScrollIndicator = true
        UIGraphicsEndImageContext()
        return img
    }
}
