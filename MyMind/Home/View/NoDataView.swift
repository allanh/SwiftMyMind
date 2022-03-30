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
        backgroundColor = .clear
        hierarchyNotReady = false
    }
    private let imageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .tertiaryLabel
        $0.image = UIImage(named: "no_data")
    }
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .brownGrey2
        $0.font = .pingFangTCRegular(ofSize: 12)
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
        let top = imageView.topAnchor.constraint(equalTo: topAnchor)
        let centerX = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        NSLayoutConstraint.activate([
            top, centerX
        ])
    }
    private func activateConstraintsTitleLabel() {
        let top = titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 7)
        let centerX = titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        NSLayoutConstraint.activate([
            top, centerX
        ])
    }
}
