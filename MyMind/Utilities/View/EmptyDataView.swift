//
//  EmptyDataView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class EmptyDataView: NiblessView {
    private let imageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "empty")
    }
    private let label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex:"848484")
        $0.font = .pingFangTCRegular(ofSize: 16)
        $0.text = "尚無資料"
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubview(imageView)
        addSubview(label)
        activateConstraintsImageView()
        activateConstraintsLabel()
    }
    private func activateConstraintsImageView() {
        let centerY = imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let centerX = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)

        NSLayoutConstraint.activate([
            centerY, centerX
        ])
    }
    private func activateConstraintsLabel() {
        let top = label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        let centerX = label.centerXAnchor.constraint(equalTo: centerXAnchor)

        NSLayoutConstraint.activate([
            top, centerX
        ])
    }
}
