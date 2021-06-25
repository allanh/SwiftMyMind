//
//  UIViewController+loadNib.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UIViewController {
    static func loadFormNib() -> Self {
        return self.init(nibName: String(describing: Self.self), bundle: nil)
    }
}
