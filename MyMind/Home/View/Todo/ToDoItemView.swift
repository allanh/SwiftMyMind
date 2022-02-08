//
//  ToDoItemView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class ToDoItemView: NiblessView {
    var hierarchyNotReady: Bool = true
    var item: ToDo.ToDoItem? = nil {
        didSet {
            if let toDo = item {
                titleLabel.text = toDo.type.displayName
                countLabel.text = String(toDo.count)
            }
        }
    }
    init(frame: CGRect, item: ToDo.ToDoItem? = nil) {
        self.item = item
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.tertiaryLabel.cgColor
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
          return
        }
        arrangeView()
        activateConstraints()
        backgroundColor = .tertiarySystemBackground
        hierarchyNotReady = false
    }
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = .secondaryLabel
    }
    private let countLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .pingFangTCSemibold(ofSize: 20)
        $0.textColor = .label
    }
}
/// helper
extension ToDoItemView {
    private func arrangeView() {
        addSubview(countLabel)
        addSubview(titleLabel)
    }
    private func activateConstraints() {
        activateConstraintsCountLabel()
        activateConstraintsTitleLabel()
    }
}
/// constraint
extension ToDoItemView {
    private func activateConstraintsTitleLabel() {
        let leading = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        let trailing = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        let height = titleLabel.heightAnchor.constraint(equalToConstant: 20)
        let bottom = titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)

        NSLayoutConstraint.activate([
            leading, trailing, height, bottom
        ])

    }
    private func activateConstraintsCountLabel() {
        let leading = countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        let trailing = countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        let height = countLabel.heightAnchor.constraint(equalToConstant: 29)
        NSLayoutConstraint(item: countLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.8, constant: 0).isActive = true

        NSLayoutConstraint.activate([
            leading, trailing, height
        ])
    }
}
