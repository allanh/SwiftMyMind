//
//  UIBarButtonItem+.swift
//  MyMind
//
//  Created by Sam Lai on 2019/10/15.
//  Copyright © 2019 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func updateBadge(number: Int, type: UIView.BadgeType = .dot, position: UIView.BadgePosition = .rightTop) {
        guard let button = customView as? UIButton,
              number > 0
        else { return }
        button.updateBadge(number: number, type: type, position: position)
    }
}
