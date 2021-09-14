//
//  StaticView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/6.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class StaticView: NiblessView {
    enum ViewType {
        case noConnection, maintenance, service
    }
    private let imageView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCSemibold(ofSize: 18)
        $0.textColor = .emperor
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let descriptionsLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.pingFangTCRegular(ofSize: 14)
        $0.textColor = UIColor(hex: "848484")
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let defaultButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: "384053")
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 4
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }
    
    let alternativeButton: UIButton = UIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "384053").cgColor
        $0.setTitleColor(UIColor(hex: "384053"), for: .normal)
        $0.titleLabel?.font = .pingFangTCSemibold(ofSize: 16)
    }
    
    let defaultButtonTitle: String?
    let alternativeButtonTitle: String?

    init(frame: CGRect = .zero,
         type: ViewType,
         title: String,
         descriptions: String,
         defaultButtonTitle: String? = nil,
         alternativeButtonTitle: String? = nil) {
        self.defaultButtonTitle = defaultButtonTitle
        self.alternativeButtonTitle = alternativeButtonTitle
        super.init(frame: frame)
        constructViewHierarchy()
        activateConstraints()
        backgroundColor = .white
        switch type {
        case .maintenance:
            imageView.image = UIImage(named: "maintenance")
        case .noConnection:
            imageView.image = UIImage(named: "no_connection")
        case .service:
            imageView.image = UIImage(named: "server_error")
        }
        titleLabel.text = title
        descriptionsLabel.text = descriptions
    }
    private func constructViewHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionsLabel)
        if let title = defaultButtonTitle {
            defaultButton.setTitle(title, for: .normal)
            addSubview(defaultButton)
        }
        if let title = alternativeButtonTitle {
            alternativeButton.setTitle(title, for: .normal)
            addSubview(alternativeButton)
        }
    }

    private func activateConstraints() {
        activateConstraintsImageView()
        activateConstraintsTitleLabel()
        activateConstraintsDescriptionsLabel()
        if let _ = defaultButtonTitle {
            activateConstraintsDefaultButton()
        }
        if let _ = alternativeButtonTitle {
            activateConstraintsAlternativeButton()
        }
    }

}
extension StaticView {
    private func activateConstraintsImageView() {
        let top = imageView.topAnchor.constraint(equalTo: topAnchor, constant: 40)
        let centerX = imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let width = imageView.widthAnchor.constraint(equalToConstant: 259)
        let height = imageView.heightAnchor.constraint(equalToConstant: 280)

        NSLayoutConstraint.activate([
            top, centerX, width, height
        ])
    }

    private func activateConstraintsTitleLabel() {
        let top = titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        let centerX = titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        let width = titleLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor)

        NSLayoutConstraint.activate([
            top, centerX, width
        ])
    }
    
    private func activateConstraintsDescriptionsLabel() {
        let top = descriptionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        let centerX = descriptionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        let width = descriptionsLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor)

        NSLayoutConstraint.activate([
            top, centerX, width
        ])
    }
    
    private func activateConstraintsDefaultButton() {
        let traling = defaultButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        let top = defaultButton.topAnchor.constraint(equalTo: descriptionsLabel.bottomAnchor, constant: 10)
        let width = defaultButton.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.4)
        let height = defaultButton.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([
            traling, top, width, height
        ])
    }
    
    private func activateConstraintsAlternativeButton() {
        let leading = alternativeButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        let top = alternativeButton.topAnchor.constraint(equalTo: descriptionsLabel.bottomAnchor, constant: 10)
        let width = alternativeButton.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.4)
        let height = alternativeButton.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([
            leading, top, width, height
        ])
    }
}
