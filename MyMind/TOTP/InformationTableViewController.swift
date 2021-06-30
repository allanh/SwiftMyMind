//
//  InformationTableViewController.swift
//  UDIAuthorizer
//
//  Created by Barry Chen on 2021/1/25.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class InformationTableViewController: UITableViewController {

    private let cellIdentifier: String = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
                // Never fails:
                return UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellIdentifier)
            }
            return cell
        }()
        cell.textLabel?.text = "版本"
        let version: String = Bundle.main.releaseVersionNumber ?? ""
        let buildNumber: String = Bundle.main.buildVersionNumber ?? ""
        cell.detailTextLabel?.text = "\(version)#\(buildNumber)"
        return cell
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
