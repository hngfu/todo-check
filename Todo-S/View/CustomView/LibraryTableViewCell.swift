//
//  LibraryTableViewCell.swift
//  ToDo S
//
//  Created by 조재흥 on 2019/11/13.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {
    
    static let identifier = "libraryTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    
    func set(with library: Library) {
        self.titleLabel.text = library.title
        self.urlTextView.text = library.url
        self.copyrightLabel.text = library.copyright
        self.licenseLabel.text = library.license
    }
}
