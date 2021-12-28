//
//  UICollectionViewCell+shadow.swift
//  MyMind
//
//  Created by Shih Allan on 2021/12/21.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
extension UICollectionViewCell {
    func addShadow() {
        // Configure the cell
        contentView.layer.cornerRadius = 16.0
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8.0)
        layer.shadowRadius = 16.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
}
