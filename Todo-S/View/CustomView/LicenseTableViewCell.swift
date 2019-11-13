//
//  LicenseTableViewCell.swift
//  ToDo S
//
//  Created by 조재흥 on 2019/11/13.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

class LicenseTableViewCell: UITableViewCell {

    static let identifier = "licenseTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func set(with license: License) {
        self.titleLabel.text = license.title
        self.contentLabel.text = license.content
    }
}
