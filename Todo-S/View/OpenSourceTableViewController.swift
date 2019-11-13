//
//  OpenSourceTableViewController.swift
//  ToDo S
//
//  Created by 조재흥 on 2019/11/13.
//  Copyright © 2019 Hngfu. All rights reserved.
//

import UIKit

class OpenSourceTableViewController: UITableViewController {
    
    private let libraries: [Library] = [
        Library(title: "Action",
                url: "https://github.com/RxSwiftCommunity/Action",
                copyright: "Copyright (c) 2015 Ash Furrow",
                license: "MIT License"),
        Library(title: "RxSwift",
                url: "https://github.com/ReactiveX/RxSwift",
                copyright: "Copyright © 2015 Krunoslav Zaher",
                license: "MIT License"),
        Library(title: "RxDataSources",
                url: "https://github.com/RxSwiftCommunity/RxDataSources",
                copyright: "Copyright (c) 2017 RxSwift Community",
                license: "MIT License"),
        Library(title: "RxGesture",
                url: "https://github.com/RxSwiftCommunity/RxGesture",
                copyright: "Copyright (c) RxSwiftCommunity",
                license: "MIT License"),
        Library(title: "RxKeyboard",
                url: "https://github.com/RxSwiftCommunity/RxKeyboard",
                copyright: "Copyright (c) 2016 Suyeol Jeon (xoul.kr)",
                license: "MIT License"),
        Library(title: "RxOptional",
                url: "https://github.com/RxSwiftCommunity/RxOptional",
                copyright: "Copyright (c) 2016 Thane Gill <me@thanegill.com>",
                license: "MIT License"),
        Library(title: "RxRealm",
                url: "https://github.com/RxSwiftCommunity/RxRealm",
                copyright: "Copyright (c) 2016 RxSwiftCommunity",
                license: "MIT License"),
        Library(title: "SnapKit",
                url: "https://github.com/SnapKit/SnapKit",
                copyright: "Copyright (c) 2011-Present SnapKit Team - https://github.com/SnapKit",
                license: "MIT License"),
    ]
    
    private let licenses: [License] = [
        License(title: "MIT License",
                content: """
        MIT License

        Copyright (c) <year> <copyright holders>

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in
        all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
        THE SOFTWARE.
        """
        ),
    ]

    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OpenSourceTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return libraries.count
        case 1:
            return licenses.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: LibraryTableViewCell.identifier,
                                                     for: indexPath)
            guard let libraryTableViewCell = cell as? LibraryTableViewCell else { return cell }
            libraryTableViewCell.set(with: libraries[indexPath.row])
            return libraryTableViewCell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: LicenseTableViewCell.identifier,
                                                     for: indexPath)
            guard let licenseTableViewCell = cell as? LicenseTableViewCell else { return cell }
            licenseTableViewCell.set(with: licenses[indexPath.row])
            return licenseTableViewCell
        default:
            return UITableViewCell()
        }
    }
}
