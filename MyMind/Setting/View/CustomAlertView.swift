//
//  CustomAlertView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/3.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//
import UIKit
class CustomAlertView: NiblessView {
    var hierarchyNotReady: Bool = true
    let title: String
    let descriptions: String
    let needCancel: Bool
    init(frame: CGRect, title: String, descriptions: String, needCancel: Bool = true) {
        self.title = title
        self.descriptions = descriptions
        self.needCancel = needCancel
        super.init(frame: frame)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
          return
        }
        arrangeView()
        activateConstraints()
        alertTitleLabel.text = title
        alertDescriptionsLabel.text = descriptions
        backgroundColor = .black.withAlphaComponent(0.6)
        hierarchyNotReady = false
    }
    private let alertBackgroundView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black.withAlphaComponent(0.75)
    }
    private let alertView: UIView = UIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    private let alertTitleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .emperor
        $0.font = .pingFangTCSemibold(ofSize: 22)
    }
    private let alertDescriptionsLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .brownGrey
        $0.font = .pingFangTCRegular(ofSize: 14)
        $0.numberOfLines = 2
    }
    let confirmButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "384053")
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("確定", for: .normal)
        $0.layer.cornerRadius = 4
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)

    }
    let cancelButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "384053").cgColor
        $0.setTitleColor(UIColor(hex: "384053"), for: .normal)
        $0.setTitle("取消", for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }

}
/// helper
extension CustomAlertView {
    private func arrangeView() {
        alertView.addSubview(alertTitleLabel)
        alertView.addSubview(alertDescriptionsLabel)
        alertView.addSubview(confirmButton)
        if needCancel {
            alertView.addSubview(cancelButton)
        }
        addSubview(alertView)
    }
    private func activateConstraints() {
        activateConstraintsAlertView()
        activateConstraintsAlertTitleLabel()
        activateConstraintsAlertDescriptionsLabel()
        activateConstraintsAlertConfirmButton()
        if needCancel {
            activateConstraintsAlertCancelButton()
        }
    }
}
/// constraints
extension CustomAlertView {
    private func activateConstraintsAlertBackgroundView() {
        let top = alertBackgroundView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let bottom = alertBackgroundView.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        let leading = alertBackgroundView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let trailing = alertBackgroundView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            top, bottom, leading, trailing
        ])
    }
    private func activateConstraintsAlertView() {
        let centerX = alertView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let centerY = alertView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let width = alertView.widthAnchor
            .constraint(equalToConstant: 320)
        let height = alertView.heightAnchor
            .constraint(equalToConstant: 240)

        NSLayoutConstraint.activate([
            centerX, centerY, width, height
        ])
    }
    private func activateConstraintsAlertTitleLabel() {
        let leading = alertTitleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16)
        let top = alertTitleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 16)
        let trailing = alertTitleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 16)
        let height = alertTitleLabel.heightAnchor.constraint(equalToConstant: 26)

        NSLayoutConstraint.activate([
            leading, top, trailing, height
        ])

    }
    private func activateConstraintsAlertDescriptionsLabel() {
        let leading = alertDescriptionsLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16)
        let top = alertDescriptionsLabel.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 16)
        let trailing = alertDescriptionsLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 16)
        let height = alertDescriptionsLabel.heightAnchor.constraint(equalToConstant: 48)

        NSLayoutConstraint.activate([
            leading, top, trailing, height
        ])
    }
    private func activateConstraintsAlertConfirmButton() {
        let traling = confirmButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16)
        let bottom = confirmButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16)
        let width = confirmButton.widthAnchor.constraint(equalToConstant: 120)
        let height = confirmButton.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([
            traling, bottom, width, height
        ])
    }
    private func activateConstraintsAlertCancelButton() {
        let traling = cancelButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -16)
        let bottom = cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16)
        let width = cancelButton.widthAnchor.constraint(equalToConstant: 120)
        let height = cancelButton.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([
            traling, bottom, width, height
        ])
    }
}
