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

    private let noteLabel: UILabel = UILabel {
        $0.textColor = UIColor(hex: "B4B4B4")
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }

    private lazy var progressLineBottomConstraint: NSLayoutConstraint = progressLineView.bottomAnchor
        .constraint(equalTo: bottomAnchor, constant: 10)

    var isFirstLog: Bool = false {
        didSet {
            let constant: CGFloat = isFirstLog ? 0 : 10
            progressLineBottomConstraint.constant = constant
        }
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
        addSubview(noteLabel)
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
        noteLabel.text = logInfo.note
    }
}
// MARK: - Layouts
extension LogInfoView {
    private func activateConstraintsDotView() {
        dotView.translatesAutoresizingMaskIntoConstraints = false
        let top = dotView.topAnchor
            .constraint(equalTo: topAnchor, constant: 10)
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

        NSLayoutConstraint.activate([
            top, centerX, width, progressLineBottomConstraint
        ])
    }

    private func activateConstraintsTimeStampLabel() {
        timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = timeStampLabel.centerYAnchor
            .constraint(equalTo: dotView.centerYAnchor)
        let leading = timeStampLabel.leadingAnchor
            .constraint(equalTo: dotView.trailingAnchor, constant: 15)

        NSLayoutConstraint.activate([
            centerY, leading
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
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        let top = noteLabel.topAnchor
            .constraint(equalTo: timeStampLabel.topAnchor)
        let leading = noteLabel.leadingAnchor
            .constraint(equalTo: timeStampLabel.trailingAnchor, constant: 25)
        let height = noteLabel.heightAnchor
            .constraint(greaterThanOrEqualToConstant: 150)
        let trailing = noteLabel.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -10)
        let bottom = noteLabel.bottomAnchor
            .constraint(equalTo: bottomAnchor)

        NSLayoutConstraint.activate([
            top, leading, height, trailing, bottom
        ])
    }
}
