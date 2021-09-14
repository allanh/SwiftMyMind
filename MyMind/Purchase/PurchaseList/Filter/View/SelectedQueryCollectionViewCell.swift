//
//  SelectedQueryCollectionViewCell.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class SelectedQueryCollectionViewCell: UICollectionViewCell {
    private let contentLabel: UILabel = UILabel {
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = .veryDarkGray
    }

    let deleteButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "filled_close"), for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHierarchy()
        activateConstraints()
        configContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configContentView() {
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .lightGray
        contentView.clipsToBounds = true

    }

    private func constructViewHierarchy() {
        contentView.addSubview(contentLabel)
        contentView.addSubview(deleteButton)
    }

    private func activateConstraints() {
        activateConstraintsContentLabel()
        activateConstraintsDeleteButton()
    }

    func config(with content: String) {
        contentLabel.text = content
    }
}
// MARK: - Layouts
extension SelectedQueryCollectionViewCell {
    private func activateConstraintsContentLabel() {
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = contentLabel.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let leading = contentLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 10)
        NSLayoutConstraint.activate([
            centerY, leading
        ])
    }

    private func activateConstraintsDeleteButton() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        let centerY = deleteButton.centerYAnchor
            .constraint(equalTo: contentLabel.centerYAnchor)
        let leading = deleteButton.leadingAnchor
            .constraint(equalTo: contentLabel.trailingAnchor, constant: 10)
        let width = deleteButton.widthAnchor
            .constraint(equalToConstant: 20)
        let height = deleteButton.heightAnchor
            .constraint(equalTo: deleteButton.widthAnchor)

        NSLayoutConstraint.activate([
            centerY, leading, width, height
        ])
    }
}
