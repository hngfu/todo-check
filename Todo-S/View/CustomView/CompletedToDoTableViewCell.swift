//
//  CompletedToDoTableViewCell.swift
//  ToDo S
//
//  Created by 조재흥 on 2019/11/10.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

class CompletedToDoTableViewCell: UITableViewCell {
    static let identifier = "completedToDoTableViewCell"
    static let nibName = "CompletedToDoTableViewCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    func setColor(isEvenIndex: Bool) {
        let evenColor = UIColor(named: "Completed ToDo Cell Color")
        let oddColor = UIColor(named: "ToDo Background Color")
        let color = isEvenIndex ? evenColor : oddColor
        containerView.backgroundColor = color
    }

    func set(with toDo: ToDo) {
        self.contentLabel.text = toDo.content
    }
}
