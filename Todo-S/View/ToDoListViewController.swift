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
import RxGesture

class ToDoListViewController: UIViewController, ViewModelBindableType {
    
    static let identifierNavigation = "ToDoListNavigation"
    
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var inputTextField: RoundCornerTextField!
    @IBOutlet weak var inputContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var movableCellLongGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var showCompletedListButton: UIBarButtonItem!
    
    var viewModel: ToDoListViewModel!
    private let disposeBag = DisposeBag()
    
    private var sourceIndexPath: IndexPath?
    private var snapShotView: UIView?
    private var beginIndexPath: IndexPath?
    
    private var oldCellCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoListTableView.register(UINib(nibName: ToDoTableViewCell.nibName, bundle: nil),
                                   forCellReuseIdentifier: ToDoTableViewCell.identifier)
        toDoListTableView.addGestureRecognizer(movableCellLongGestureRecognizer)
        inputTextField.enablesReturnKeyAutomatically = true
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)

        let toDoListObservable = viewModel.toDoList.asDriver(onErrorJustReturn: [])
        
        toDoListObservable
            .drive(toDoListTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        toDoListObservable
            .drive(onNext: { sectionModels in
                let newCellCount = sectionModels[0].items.count
                let isInserted = self.oldCellCount ?? 0 < newCellCount
                if isInserted {
                    self.scrollToLastCell()
                }
                self.oldCellCount = newCellCount
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                guard let `self` = self else { return }
                var height = height
                if #available(iOS 11, *) {
                    height = height - self.view.safeAreaInsets.bottom
                }
                UIView.animate(withDuration: 0) {
                    self.inputContainerViewBottomConstraint.constant = max(height, 0)
                    self.view.layoutIfNeeded()
                    self.scrollToLastCell()
                }
            })
            .disposed(by: disposeBag)
        
        inputTextField.rx.shouldReturn
            .withLatestFrom(inputTextField.rx.text)
            .filterNil()
            .bind(to: viewModel.createAction.inputs)
            .disposed(by: disposeBag)
        
        movableCellLongGestureRecognizer.rx.event
            .bind { [weak self] (event) in
                
                //MARK: common
                guard
                    let `self` = self
                    else { return }
                
                let location = event.location(in: self.toDoListTableView)
                
                guard
                    let indexPath = self.toDoListTableView.indexPathForRow(at: location)
                    else { return }
                
                switch event.state {
                    
                //MARK: began
                case .began:
                    self.sourceIndexPath = indexPath
                    self.beginIndexPath = indexPath
                    guard
                        let cell = self.toDoListTableView.cellForRow(at: indexPath)
                        else { return }
                    let snapShot = self.hoveringSnapShotImageView(of: cell)
                    self.snapShotView = snapShot
                    snapShot.center = cell.center
                    self.toDoListTableView.addSubview(snapShot)
                    cell.isHidden = true
                    
                //MARK: changed
                case .changed:
                    guard
                        let snapShot = self.snapShotView,
                        let sourceIndexPath = self.sourceIndexPath
                        else { return }
                    
                    snapShot.center.y = location.y
                    if indexPath != sourceIndexPath {
                        self.toDoListTableView.moveRow(at: sourceIndexPath, to: indexPath)
                        self.sourceIndexPath = indexPath
                    }
                    
                //MARK: ended
                case .ended:
                    guard
                        let cell = self.toDoListTableView.cellForRow(at: indexPath),
                        let beginIndexPath = self.beginIndexPath
                        else { return }
                    
                    self.viewModel.moveToDo(at: beginIndexPath.row, to: indexPath.row)
                    cell.isHidden = false
                    self.snapShotView?.removeFromSuperview()
                    self.sourceIndexPath = nil
                    self.snapShotView = nil
                    self.beginIndexPath = nil
                    
                default:
                    break
                }
        }.disposed(by: disposeBag)
        
        showCompletedListButton.rx.action = viewModel.makeShowCompletedListAction()
        
        showCompletedListButton.rx.tap
            .subscribe(onNext: {
                self.inputTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        toDoListTableView.setContentOffset(.zero, animated: false)
        
        toDoListTableView.rx.tapGesture()
            .subscribe(onNext: { _ in
                self.inputTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    private func hoveringSnapShotImageView(of view: UIView) -> UIImageView {
        let snapShotImage = view.snapShotImage()
        let snapShotImageView = UIImageView(image: snapShotImage)
        snapShotImageView.transform = .init(scaleX: 1.05, y: 1.05)
        snapShotImageView.alpha = 0.7
        return snapShotImageView
    }
    
    private func scrollToLastCell() {
        let countRowZeroSection = toDoListTableView.numberOfRows(inSection: 0)
        guard
            countRowZeroSection > 0
            else { return }
        
        let lastCellIndexPath = IndexPath(row: countRowZeroSection - 1, section: 0)
        toDoListTableView.scrollToRow(at: lastCellIndexPath, at: .bottom, animated: true)
    }
}
