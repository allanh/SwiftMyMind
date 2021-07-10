//
//  ToDoInfoHeaderView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class ToDoInfoHeaderView: NiblessView {
    var hierarchyNotReady: Bool = true
    let toDo: ToDo
    
    private let imageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .center
    }
    
    private let gradientBackgroundView: GridentCircleView!
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(hex: "1a2f50")
        $0.font = .pingFangTCSemibold(ofSize: 24)
    }
    private let seperatorView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .secondarySystemBackground
    }
    init(frame: CGRect, toDo: ToDo) {
        self.toDo = toDo
        self.gradientBackgroundView = GridentCircleView(gradients: toDo.type.gradients)
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
          return
        }
        arrangeView()
        activateConstraints()
        imageView.image = UIImage(named: toDo.type.imageName)
        titleLabel.text = toDo.type.displayName
        backgroundColor = .systemBackground
        hierarchyNotReady = false
    }
}
/// helper
extension ToDoInfoHeaderView {
    private func arrangeView() {
        addSubview(gradientBackgroundView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(seperatorView)
    }
    private func activateConstraints() {
        activateConstraintsGradientBackgroundView()
        activateConstraintsImageView()
        activateConstraintsTitleLabel()
        activateConstraintsSeperatorView()
    }
}
/// constraints
extension ToDoInfoHeaderView {
    private func activateConstraintsGradientBackgroundView() {
        let centerY = gradientBackgroundView.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let width = gradientBackgroundView.widthAnchor
            .constraint(equalToConstant: 40)
        let height = gradientBackgroundView.heightAnchor
            .constraint(equalToConstant: 40)
        let leading = gradientBackgroundView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 15)

        NSLayoutConstraint.activate([
            centerY, width, height, leading
        ])
    }
    private func activateConstraintsImageView() {
        let centerY = imageView.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let width = imageView.widthAnchor
            .constraint(equalToConstant: 40)
        let height = imageView.heightAnchor
            .constraint(equalToConstant: 40)
        let leading = imageView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 15)

        NSLayoutConstraint.activate([
            centerY, width, height, leading
        ])
    }
    private func activateConstraintsTitleLabel() {
        let centerY = titleLabel.centerYAnchor
            .constraint(equalTo: centerYAnchor)
        let trailing = titleLabel.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: 15)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: imageView.trailingAnchor, constant: 15)

        NSLayoutConstraint.activate([
            centerY, leading, trailing
        ])
    }
    private func activateConstraintsSeperatorView() {
        let trailing = seperatorView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: 0)
        let leading = seperatorView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 0)
        let height = seperatorView.heightAnchor
            .constraint(equalToConstant: 1)
        let bottom = seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
        NSLayoutConstraint.activate([
            leading, trailing, height, bottom
        ])

    }

}
