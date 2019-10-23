//
//  RxUITextFieldDelegateProxy.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/23.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit
import RxCocoa

class RxUITextFieldDelegateProxy: DelegateProxy<UITextField, UITextFieldDelegate>, DelegateProxyType, UITextFieldDelegate {
    weak private(set) var textField: UITextField?
    
    init(textField: UITextField) {
        self.textField = textField
        super.init(parentObject: textField, delegateProxy: RxUITextFieldDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register {
            RxUITextFieldDelegateProxy(textField: $0)
        }
    }
    
    @objc
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}

extension UITextField: HasDelegate {
    public typealias Delegate = UITextFieldDelegate
}
