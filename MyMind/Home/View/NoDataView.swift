//
//  NoDataView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/14.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class NoDataView: NiblessView {
    var hierarchyNotReady: Bool = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
          return
        }
        arrangeView()
        activateConstraints()
        backgroundColor = .systemBackground
        hierarchyNotReady = false
    }
    private let imageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .tertiaryLabel
        $0.image = UIImage(named: "empty")
    }
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .secondaryLabel
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.text = "尚無資料"
    }
}
/// helper
extension NoDataView {
    private func arrangeView() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    private func activateConstraints() {
        activateConstraintsImageView()
        activateConstraintsTitleLabel()
    }
}
/// constraints
extension NoDataView {
    private func activateConstraintsImageView() {
        let centerY = imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let centerX = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        NSLayoutConstraint.activate([
            centerY, centerX
        ])
    }
    private func activateConstraintsTitleLabel() {
        let top = titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        let centerX = titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        NSLayoutConstraint.activate([
            top, centerX
        ])
    }
}
