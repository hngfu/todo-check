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
    @IBOutlet weak var inputButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var inputTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var movableCellLongGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var showCompletedListButton: UIBarButtonItem!
    
    var viewModel: ToDoListViewModel!
    private let disposeBag = DisposeBag()
    
    private var sourceIndexPath: IndexPath?
    private var snapShotView: UIView?
    private var beginIndexPath: IndexPath?
    
    private var oldCellCount: Int?
    
    private let minHeightInputTextView: CGFloat = 37
    private let maxHeightInputTextView: CGFloat = 117
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: ToDoTableViewCell.nibName, bundle: nil)
        toDoListTableView.register(nib, forCellReuseIdentifier: ToDoTableViewCell.identifier)
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
            .drive(onNext: { [weak self] sectionModels in
                guard let `self` = self else { return }
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
                let height = height - self.view.safeAreaInsets.bottom
                self.inputContainerViewBottomConstraint.constant = max(height, 0)
                self.view.layoutIfNeeded()
                self.scrollToLastCell()
            })
            .disposed(by: disposeBag)

        let inputButtonObservable = inputButton.rx.tap.share()
        inputButtonObservable
            .withLatestFrom(inputTextView.rx.text.orEmpty)
            .bind(to: viewModel.createAction.inputs)
            .disposed(by: disposeBag)
        
        inputButtonObservable
            .subscribe(onNext: { _ in
                self.inputTextView.text = ""
                self.inputTextViewHeightConstraint.constant = self.minHeightInputTextView
            })
            .disposed(by: disposeBag)
        
        inputTextView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        inputTextView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: inputButton.rx.isEnabled, placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        movableCellLongGestureRecognizer.rx.event
            .bind { [weak self] (event) in
                
                //MARK: common
                guard let `self` = self else { return }
                let location = event.location(in: self.toDoListTableView)

                switch event.state {
                //MARK: began
                case .began:
                    guard
                        let indexPath = self.toDoListTableView.indexPathForRow(at: location),
                        let cell = self.toDoListTableView.cellForRow(at: indexPath)
                        else { return }
                    
                    self.sourceIndexPath = indexPath
                    self.beginIndexPath = indexPath
                    let snapShot = self.hoveringSnapShotImageView(of: cell)
                    self.snapShotView = snapShot
                    snapShot.center = cell.center
                    self.toDoListTableView.addSubview(snapShot)
                    cell.isHidden = true
                    
                //MARK: changed
                case .changed:
                    guard
                        let indexPath = self.toDoListTableView.indexPathForRow(at: location),
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
                        let indexPath = self.sourceIndexPath,
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
        
        let showListButton = showCompletedListButton.rx.tap.map { _ in return () }
        let tapGestureObservable = toDoListTableView.rx.tapGesture().map { _ in return () }
        Observable.merge(showListButton, tapGestureObservable)
            .subscribe(onNext: { [weak self] in
                self?.inputTextView.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        toDoListTableView.setContentOffset(.zero, animated: false)
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
        guard countRowZeroSection > 0 else { return }
        let lastCellIndexPath = IndexPath(row: countRowZeroSection - 1, section: 0)
        toDoListTableView.scrollToRow(at: lastCellIndexPath, at: .bottom, animated: true)
    }
}

extension ToDoListViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textViewHeight = self.inputTextView.contentSize.height
        if textViewHeight < self.minHeightInputTextView {
            inputTextViewHeightConstraint.constant = self.minHeightInputTextView
        } else if textViewHeight > self.maxHeightInputTextView {
            inputTextViewHeightConstraint.constant = self.maxHeightInputTextView
        } else {
            inputTextViewHeightConstraint.constant = textViewHeight
        }
        textView.layoutIfNeeded()
        let bottomPointY = textView.contentSize.height - inputTextViewHeightConstraint.constant
        textView.setContentOffset(.init(x: 0, y: bottomPointY), animated: false)
    }
}
