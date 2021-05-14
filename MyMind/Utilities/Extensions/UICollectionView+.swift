//
//  UICollectionView+.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerCellFormNib(for cellClass: AnyClass) {
        register(UINib(nibName: String(describing: cellClass), bundle: nil), forCellWithReuseIdentifier: String(describing: cellClass))
    }

    func registerCell(_ cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }

    func dequeueReusableCell(_ cellClass: AnyClass, for indexPath: IndexPath) -> UICollectionViewCell {
        dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath)
    }
}
