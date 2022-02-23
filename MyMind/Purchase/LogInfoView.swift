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
        $0.layer.borderColor = UIColor.prussianBlue.cgColor
    }

    private let progressLineView: UIView = UIView {
        $0.backgroundColor = .separator
    }

    private let timeStampLabel: UILabel = UILabel {
        $0.textColor = .prussianBlue
        $0.font = .pingFangTCSemibold(ofSize: 14)
    }

    private let createrLabel: UILabel = UILabel {
        $0.textColor = .tundora
        $0.font = .pingFangTCRegular(ofSize: 14)
    }

    private let createrNameLabel: UILabel = UILabel {
        $0.textColor = .tundora
        $0.font = .pingFangTCRegular(ofSize: 14)
    }
    
    private let statusLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .tundora
        $0.font = .pingFangTCRegular(ofSize: 14)
    }

    private let noteTextView: UITextView = UITextView {
        $0.textColor = .brownGrey2
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.textAlignment = .left
        $0.isScrollEnabled = false
        $0.isEditable = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.textContainer.lineFragmentPadding = .zero
        $0.textContainerInset = .zero
    }

    private var noteTextViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
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
        addSubview(statusLabel)
        addSubview(noteTextView)
    }

    private func activateConstraints() {
        activateConstraintsDotView()
        activateConstraintsProgressLineView()
        activateConstraintsTimeStampLabel()
        activateConstriantsCreaterLabel()
        activateConstriantsCreaterNameLabel()
        activateConstraintsStatusLabel()
        activateConstraintsNoteLabel()
    }

    func configure(with logInfo: PurchaseOrder.LogInfo) {
        timeStampLabel.text = logInfo.createdDateString
        createrLabel.text = logInfo.creater
        createrNameLabel.text = logInfo.createrName
        statusLabel.text = logInfo.status.description
        noteTextView.text = logInfo.note
        let height = logInfo.note?.height(withConstrainedWidth: noteTextView.bounds.width, font: .pingFangTCRegular(ofSize: 14))
        noteTextViewHeightConstraint.constant = height ?? 0
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
        let trailing = timeStampLabel.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -10)

        NSLayoutConstraint.activate([
            centerY, leading, trailing
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
    private func activateConstraintsStatusLabel() {
        let top = statusLabel.topAnchor
            .constraint(equalTo: createrNameLabel.bottomAnchor, constant: 10)
        let leading = statusLabel.leadingAnchor
            .constraint(equalTo: timeStampLabel.leadingAnchor)

        NSLayoutConstraint.activate([
            top, leading
        ])

    }
    private func activateConstraintsNoteLabel() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        let top = noteTextView.topAnchor
            .constraint(equalTo: statusLabel.bottomAnchor, constant: 10)
        let leading = noteTextView.leadingAnchor
            .constraint(equalTo: timeStampLabel.leadingAnchor)
        let trailing = noteTextView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -10)
        noteTextViewHeightConstraint = noteTextView.heightAnchor
            .constraint(greaterThanOrEqualToConstant: 150)
        let bottom = noteTextView.bottomAnchor
            .constraint(equalTo: bottomAnchor, constant: -10)

        NSLayoutConstraint.activate([
            top, leading, trailing, noteTextViewHeightConstraint, bottom
        ])
    }
}
