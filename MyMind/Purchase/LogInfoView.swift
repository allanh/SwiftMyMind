//
//  LogInfoView.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/22.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class LogInfoView: NiblessView {
    private let dotView: UIView = UIView {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 5
        $0.layer.borderColor = UIColor(hex: "004477").cgColor
    }

    private let progressLineView: UIView = UIView {
        $0.backgroundColor = .separator
    }

    private let timeStampLabel: UILabel = UILabel {
        $0.textColor = UIColor(hex: "004477")
        $0.font = .pingFangTCSemibold(ofSize: 14)
    }

    private let createrLabel: UILabel = UILabel {
        $0.textColor = UIColor(hex: "434343")
        $0.font = .pingFangTCRegular(ofSize: 14)
    }

    private let createrNameLabel: UILabel = UILabel {
        $0.textColor = UIColor(hex: "434343")
        $0.font = .pingFangTCRegular(ofSize: 14)
    }

    private let noteTextView: UITextView = UITextView {
        $0.textColor = UIColor(hex: "B4B4B4")
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textAlignment = .left
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.textContainer.lineFragmentPadding = .zero
        $0.textContainerInset = .zero
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        constructViewHierarchy()
        activateConstraints()
    }

    private func constructViewHierarchy() {
        addSubview(progressLineView)
        addSubview(dotView)
        addSubview(timeStampLabel)
        addSubview(createrLabel)
        addSubview(createrNameLabel)
        addSubview(noteTextView)
    }

    private func activateConstraints() {
        activateConstraintsDotView()
        activateConstraintsProgressLineView()
        activateConstraintsTimeStampLabel()
        activateConstriantsCreaterLabel()
        activateConstriantsCreaterNameLabel()
        activateConstraintsNoteLabel()
    }

    func configure(with logInfo: PurchaseOrder.LogInfo) {
        timeStampLabel.text = logInfo.createdDateString
        createrLabel.text = logInfo.creater
        createrNameLabel.text = logInfo.createrName
        noteTextView.text = logInfo.note
    }
}
// MARK: - Layouts
extension LogInfoView {
    private func activateConstraintsDotView() {
        dotView.translatesAutoresizingMaskIntoConstraints = false
        let top = dotView.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = dotView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 10)
        let width = dotView.widthAnchor
            .constraint(equalToConstant: 20)
        let height = dotView.heightAnchor
            .constraint(equalTo: dotView.widthAnchor)

        NSLayoutConstraint.activate([
            top, leading, width, height
        ])
    }

    private func activateConstraintsProgressLineView() {
        progressLineView.translatesAutoresizingMaskIntoConstraints = false
        let top = progressLineView.topAnchor
            .constraint(equalTo: dotView.bottomAnchor)
        let centerX = progressLineView.centerXAnchor
            .constraint(equalTo: dotView.centerXAnchor)
        let width = progressLineView.widthAnchor
            .constraint(equalToConstant: 1)
        let bottom = progressLineView.bottomAnchor
            .constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([
            top, centerX, width, bottom
        ])
    }

    private func activateConstraintsTimeStampLabel() {
        timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = timeStampLabel.centerYAnchor
            .constraint(equalTo: dotView.centerYAnchor)
        let leading = timeStampLabel.leadingAnchor
            .constraint(equalTo: dotView.trailingAnchor, constant: 15)
        let width = timeStampLabel.widthAnchor
            .constraint(equalToConstant: 142)

        NSLayoutConstraint.activate([
            centerY, leading, width
        ])
    }

    private func activateConstriantsCreaterLabel() {
        createrLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = createrLabel.topAnchor
            .constraint(equalTo: timeStampLabel.bottomAnchor, constant: 10)
        let leading = createrLabel.leadingAnchor
            .constraint(equalTo: timeStampLabel.leadingAnchor)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }

    private func activateConstriantsCreaterNameLabel() {
        createrNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = createrNameLabel.topAnchor
            .constraint(equalTo: createrLabel.bottomAnchor, constant: 10)
        let leading = createrNameLabel.leadingAnchor
            .constraint(equalTo: timeStampLabel.leadingAnchor)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }

    private func activateConstraintsNoteLabel() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        let top = noteTextView.topAnchor
            .constraint(equalTo: createrLabel.bottomAnchor, constant: 10)
        let leading = noteTextView.leadingAnchor
            .constraint(equalTo: timeStampLabel.leadingAnchor)
        let trailing = noteTextView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -10)
        let height = noteTextView.heightAnchor
            .constraint(greaterThanOrEqualToConstant: 150)
        let bottom = noteTextView.bottomAnchor
            .constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([
            top, leading, trailing, height, bottom
        ])
    }
}
