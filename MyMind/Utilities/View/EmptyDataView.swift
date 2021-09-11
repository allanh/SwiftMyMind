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
    }
    private let label: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    init(frame: CGRect, icon: String = "empty", description: String = "尚無資料", font: UIFont = .pingFangTCRegular(ofSize: 16), color: UIColor = UIColor(hex: "848484")) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubview(imageView)
        addSubview(label)
        imageView.image = UIImage(named: icon)
        label.font = font
        label.text = description
        label.textColor = color
        activateConstraintsImageView()
        activateConstraintsLabel()
    }
    private func activateConstraintsImageView() {
        let centerY = imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -18)
        let centerX = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        NSLayoutConstraint.activate([
            centerY, centerX
        ])
    }
    private func activateConstraintsLabel() {
        let top = label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
        let centerX = label.centerXAnchor.constraint(equalTo: centerXAnchor)

        NSLayoutConstraint.activate([
            top, centerX
        ])
    }
}
