//
//  UITableView+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }

    func dequeReusableCell(_ cellClass: AnyClass, for indexPath: IndexPath) -> UITableViewCell {
        dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath)
    }
    
    func deselectSelectedRow(animated: Bool) {
        if let indexPathForSelectedRow = self.indexPathForSelectedRow {
            self.deselectRow(at: indexPathForSelectedRow, animated: animated)
        }
    }
}
