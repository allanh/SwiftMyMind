//
//  AutoCompleteSearchRootView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/7.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class AutoCompleteSearchRootView: NiblessView {
    let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCSemibold(ofSize: 18)
        $0.textColor = UIColor(hex: "4c4c4c")
    }

    let textField: CustomClearButtonPositionTextField = CustomClearButtonPositionTextField {
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "4c4c4c")
        $0.setLeftPaddingPoints(10)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.separator.cgColor
        let containerView = UIView()
        containerView.frame = CGRect(origin: .zero, size: .init(width: 35, height: 25))
        let iconImageView = UIImageView(image: UIImage(named: "search"))
        iconImageView.frame = CGRect(origin: .zero, size: .init(width: 25, height: 25))
        containerView.addSubview(iconImageView)
        $0.rightView = containerView
        $0.rightViewMode = .unlessEditing
        $0.clearButtonMode = .whileEditing
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewLeftAlignedLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    lazy var collectionViewHeightAnchor: NSLayoutConstraint = {
        return self.collectionView.heightAnchor.constraint(equalToConstant: 0)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHierarchy()
        activateConstraints()
    }

    func constructViewHierarchy() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(collectionView)
    }

    func activateConstraints() {
        activateConstraintsTitleLabel()
        activateConstraintsTextField()
        activateConstraintsCollectionView()
    }
}
// MARK: - Layouts
extension AutoCompleteSearchRootView {
    private func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = titleLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: 15)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 20)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }

    private func activateConstraintsTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        let top = textField.topAnchor
            .constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
        let leading = textField.leadingAnchor
            .constraint(equalTo: titleLabel.leadingAnchor)
        let trailing = textField.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -20)
        let height = textField.heightAnchor
            .constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }

    private func activateConstraintsCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionView.topAnchor
            .constraint(equalTo: textField.bottomAnchor, constant: 20)
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: textField.leadingAnchor)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: textField.trailingAnchor)
        let bottom = collectionView.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -15)

        NSLayoutConstraint.activate([
            top, leading, trailing, collectionViewHeightAnchor, bottom
        ])
    }
}
