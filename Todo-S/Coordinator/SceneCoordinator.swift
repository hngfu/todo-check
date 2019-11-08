//
//  SceneCoordinator.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/28.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit
import RxSwift

class SceneCoordinator: CoordinatorType {
    
    private let window: UIWindow
    private var currentViewController: UIViewController
    private let disposeBag = DisposeBag()
    
    required init(window: UIWindow) {
        self.window = window
        self.currentViewController = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        guard let target = scene.instantiate() else {
            subject.onError(SceneError.failedToInstantiate)
            return subject.ignoreElements()
        }
        
        switch style {
            
            //MARK: Root
        case .root:
            currentViewController = target.sceneViewController()
            window.rootViewController = target
            subject.onCompleted()
            
            //MARK: Push
        case .push:
            guard let nav = currentViewController.navigationController else {
                subject.onError(TransitionError.missingNavigationController)
                break
            }
            
            nav.rx.willShow
                .subscribe(onNext: { [weak self] event in
                    self?.currentViewController = event.viewController
                })
                .disposed(by: disposeBag)
            
            nav.pushViewController(target, animated: animated)
            subject.onCompleted()
            
            //MARK: Modal
        case .modal:
            currentViewController.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentViewController = target.sceneViewController()
        }
        
        return subject.ignoreElements()
    }
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        
        if let presentingVC = self.currentViewController.presentingViewController {
            self.currentViewController.dismiss(animated: animated) {
                self.currentViewController = presentingVC.sceneViewController()
                subject.onCompleted()
            }
            
        } else if let nav = self.currentViewController.navigationController {
            nav.popViewController(animated: animated)
            subject.onCompleted()
            
        } else {
            subject.onError(TransitionError.unknown)
        }
        
        return subject.ignoreElements()
    }
}
