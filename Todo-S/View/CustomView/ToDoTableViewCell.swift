//
//  ToDoTableViewCell.swift
//  Todo-S
//
//  Created by 조재흥 on 2019/10/24.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit
import RxCocoa

class ToDoTableViewCell: UITableViewCell {
    static let identifier = "toDoTableViewCell"
    static let nibName = "ToDoTableViewCell"
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
}
