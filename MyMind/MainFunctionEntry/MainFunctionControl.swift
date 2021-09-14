//
//  MainFunctionControl.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/27.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class MainFunctionControl: UIControl {
    // MARK: - Properties
    let functionType: MainFunctoinType

    let contentView: UIView = UIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }

    let imageContainerView: UIView = UIView {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
    }

    let gradientLayer: CAGradientLayer = CAGradientLayer {
        $0.colors = [
            UIColor(hex: "ecedf0").cgColor,
            UIColor(hex: "fafafa").cgColor
        ]
    }

    let imageView: UIImageView = UIImageView {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
    }

    let titleLabel: UILabel = UILabel {
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textColor = .emperor
        $0.backgroundColor = .white
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
    }
    // MARK: - Methods
    init(frame: CGRect = .zero, mainFunctionType: MainFunctoinType) {
        functionType = mainFunctionType
        titleLabel.text = functionType.rawValue
        super.init(frame: frame)
        initialLayoutSetUp()
        isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        let containerViewBounds = imageContainerView.bounds
        gradientLayer.frame = containerViewBounds
        imageContainerView.layer.insertSublayer(gradientLayer, at: 0)
    }

    func initialLayoutSetUp() {
        constructViewHierarchy()
        activateConstraints()
        backgroundColor = .clear
        layer.cornerRadius = contentView.layer.cornerRadius
        layer.masksToBounds = false
        applySketchShadow(
            color: UIColor(hex: "b8babe"),
            alpha: 1,
            x: 2, y: 2,
            blur: 6,
            spread: 0
        )
    }

    func constructViewHierarchy() {
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        addSubview(contentView)
    }

    func activateConstraints() {
        activateConstraintsContentView()
        activateConstraintsImageContainerView()
        activateConstraintsImageView()
        activateConstraintsTitleLabel()
    }
}
// MARK: - Layouts
extension MainFunctionControl {
    func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let top = contentView.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = contentView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = contentView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
        let trailing = contentView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    func activateConstraintsImageContainerView() {
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        let top = imageContainerView.topAnchor
            .constraint(equalTo: contentView.topAnchor)
        let leading = imageContainerView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let trailing = imageContainerView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let bottom = imageContainerView.bottomAnchor
            .constraint(equalTo: titleLabel.topAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }

    func activateConstraintsImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = imageView.centerXAnchor
            .constraint(equalTo: imageContainerView.centerXAnchor)
        let centerY = imageView.centerYAnchor
            .constraint(equalTo: imageContainerView.centerYAnchor)
        let width = imageView.widthAnchor
            .constraint(equalTo: imageContainerView.widthAnchor, multiplier: 0.4)
        let height = imageView.heightAnchor
            .constraint(equalTo: imageView.widthAnchor)

        NSLayoutConstraint.activate([
            centerX, centerY, width, height
        ])
    }

    func activateConstraintsTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let leading = titleLabel.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let bottom = titleLabel.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
        let trailing = titleLabel.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let height = titleLabel.heightAnchor
            .constraint(equalToConstant: 35)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }
}
