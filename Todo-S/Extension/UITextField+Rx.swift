//
//  UITextField+Rx.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/23.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var delegate: DelegateProxy<UITextField, UITextFieldDelegate> {
        return RxUITextFieldDelegateProxy.proxy(for: base)
    }
    
    /// 1. Do not resignFirstResponder
    /// 2. Clean textField.text
    var shouldReturn: ControlEvent<Void> {
        let source = delegate.rx.methodInvoked(#selector(UITextFieldDelegate.textFieldShouldReturn(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
