//
//  UIView+Badge.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/13.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
extension UIView {
    enum BadgeType {
        case dot, number
    }
    enum BadgePosition {
        case leftTop, rightTop, leftBottom, rightBottom
    }
    func updateBadge(number: Int, type: BadgeType = .dot, position: BadgePosition = .rightTop) {
        var displayString: String = ""
        var badgeSize: CGSize = .zero
        switch type {
        case .dot:
            badgeSize = number > 0 ? CGSize(width: 8, height: 8) : .zero
        case .number:
            displayString = number > 99 ? "99+" : String(number)
            let displayStringSize = (displayString as NSString).size(withAttributes: [.font:  UIFont.pingFangTCSemibold(ofSize: 12)])
            badgeSize = CGSize(width: displayStringSize.width + 9, height: 17)
        }
        for subview in subviews where subview.accessibilityIdentifier == "Badge" {
            if let badgeLabel = subview as? UILabel {
                badgeLabel.removeConstraints(badgeLabel.constraints)
                badgeLabel.text = displayString
                badgeLabel.widthAnchor.constraint(equalToConstant: badgeSize.width).isActive = true
                badgeLabel.heightAnchor.constraint(equalToConstant: badgeSize.height).isActive = true
                badgeLabel.isHidden = number <= 0
                return
            }
        }
        guard number > 0 else { return }
        
        let badgeLabel: UILabel = UILabel {
            $0.backgroundColor = UIColor(hex: "f5222d")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = badgeSize.height/2
            $0.textColor = .white
            $0.font = UIFont.pingFangTCSemibold(ofSize: 12)
            $0.textAlignment = .center
            $0.text = displayString
            $0.accessibilityIdentifier = "Badge"
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(badgeLabel)
        switch position {
        case .rightTop:
            badgeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: (type == .dot) ? 0 : 0).isActive = true
            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        case .leftTop:
            badgeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (type == .dot) ? -2 : 0).isActive = true
            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: -2).isActive = true
        case .leftBottom:
            badgeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (type == .dot) ? -2 : 0).isActive = true
            badgeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2).isActive = true
        case .rightBottom:
            badgeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: (type == .dot) ? -2 : 0).isActive = true
            badgeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 2).isActive = true
        }
        badgeLabel.widthAnchor.constraint(equalToConstant: badgeSize.width).isActive = true
        badgeLabel.heightAnchor.constraint(equalToConstant: badgeSize.height).isActive = true
    }
}
