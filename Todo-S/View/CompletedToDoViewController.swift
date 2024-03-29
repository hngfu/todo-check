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
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: CompletedToDoTableViewCell.nibName, bundle: nil)
        completedToDoListTableView.register(nib, forCellReuseIdentifier: CompletedToDoTableViewCell.identifier)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
        super.viewDidDisappear(animated)
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        let toDoListObservable = viewModel.toDoList.asDriver(onErrorJustReturn: [])
        
        toDoListObservable
            .drive(completedToDoListTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        let hasCellObservable = toDoListObservable
            .map { sectionModels -> Bool in
                let hasCell = sectionModels[0].items.count > 0
                return hasCell
            }
            .distinctUntilChanged()
        
        hasCellObservable
            .drive(shareButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        hasCellObservable
            .drive(deleteButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let alert = UIAlertController(title: nil, message: "완료된 To Do들이 모두 삭제됩니다.".localized, preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "취소".localized, style: .cancel)
                let deleteAction = UIAlertAction(title: "모두 삭제".localized, style: .destructive, handler: { _ in self?.viewModel.deleteAllCompletedToDo() })
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let img = self?.contentImage() else { return }
                let vc = UIActivityViewController(activityItems: [img], applicationActivities: nil)
                self?.present(vc, animated: true, completion: nil)
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
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        tmpView.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        tmpView.removeFromSuperview()
        self.view.addSubview(completedToDoListTableView)

        completedToDoListTableView.snp.makeConstraints { [weak self] (make) in
            guard let `self` = self else { return }
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
