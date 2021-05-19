//
//  PickProductMaterialTableViewCell.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import Kingfisher

class PickProductMaterialTableViewCell: UITableViewCell {

    let materialImageView: UIImageView = UIImageView {
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.separator.cgColor
        $0.clipsToBounds = true
    }

    let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCSemibold(ofSize: 16)
        $0.textColor = UIColor(hex: "4c4c4c")
    }

    let numberLabel: UILabel = UILabel {
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "b4b4b4")
    }

    let checkBoxButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "checked"), for: .selected)
        $0.setImage(UIImage(named: "unchecked"), for: .normal)
    }

    private var viewHierarchyNotReady: Bool = true

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        materialImageView.kf.cancelDownloadTask()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard viewHierarchyNotReady else { return }
        constructViewHierarchy()
        activateConstratins()
        viewHierarchyNotReady = false
    }

    private func constructViewHierarchy() {
        contentView.addSubview(materialImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(checkBoxButton)
    }

    private func activateConstratins() {
        activateConstraintsMaterialImageView()
        activateConstraintsTitleLabel()
        activateConstraintsNumberLabel()
        activateConstraintsCheckedBoxButton()
    }

    func config(with material: ProductMaterial) {
        if let urlString = material.imageInfoList.first?.url,
           let url = URL(string: urlString) {
            materialImageView.kf.setImage(with: url)
        } else {
            materialImageView.image = nil
        }
        titleLabel.text = material.name
        numberLabel.text = material.number
    }
}
// MARK: Layouts
extension PickProductMaterialTableViewCell {
    private func activateConstraintsMaterialImageView() {
        materialImageView.translatesAutoresizingMaskIntoConstraints = false
        let top = materialImageView.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 15)
        let bottom = materialImageView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor, constant: -15)
        let leading = materialImageView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 15)
        let width = materialImageView.widthAnchor
            .constraint(equalTo: materialImageView.heightAnchor)

        NSLayoutConstraint.activate([
            top, bottom, leading, width
        ])
    }

    private func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = titleLabel.topAnchor
            .constraint(equalTo: materialImageView.topAnchor)
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: materialImageView.trailingAnchor, constant: 10)
        let trailing = titleLabel.trailingAnchor
            .constraint(equalTo: checkBoxButton.leadingAnchor, constant: -10)

        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }

    private func activateConstraintsNumberLabel() {
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        let bottom = numberLabel.bottomAnchor
            .constraint(equalTo: materialImageView.bottomAnchor)
        let leading = numberLabel.leadingAnchor
            .constraint(equalTo: titleLabel.leadingAnchor)
        let trailing = numberLabel.trailingAnchor
            .constraint(equalTo: titleLabel.trailingAnchor)

        NSLayoutConstraint.activate([
            bottom, leading, trailing
        ])
    }

    private func activateConstraintsCheckedBoxButton() {
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        let centerY = checkBoxButton.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
        let trailing = checkBoxButton.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor, constant: -15)
        let width = checkBoxButton.widthAnchor
            .constraint(equalToConstant: 20)
        let height = checkBoxButton.heightAnchor
            .constraint(equalTo: checkBoxButton.widthAnchor)

        NSLayoutConstraint.activate([
            centerY, trailing, width, height
        ])
    }
}
