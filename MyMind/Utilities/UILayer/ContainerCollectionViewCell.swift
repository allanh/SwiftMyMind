//
//  ContainerCollectionViewCell.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/2.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class ContainerCollectionViewCell: UICollectionViewCell {

    private weak var _hostedView: UIView? {
        didSet {
            if oldValue?.isDescendant(of: self) == true {
                oldValue?.removeFromSuperview()
            }

            if let view = _hostedView {
                contentView.addSubview(view)
                activateConstraints(view)
            }
        }
    }

    weak var hostedView: UIView? {
        get {
            _hostedView
        }
        set {
            _hostedView = newValue
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        _hostedView = nil
    }

    private func activateConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let top = view.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        let leading = view.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let bottom = view.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
        let trailing = view.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }
}
