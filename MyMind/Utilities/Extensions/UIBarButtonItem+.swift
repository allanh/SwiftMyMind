//
//  UIBarButtonItem+.swift
//  MyMind
//
//  Created by Sam Lai on 2019/10/15.
//  Copyright © 2019 United Digital Intelligence. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    enum BadgeType {
        case dot, number
    }
    enum BadgePosition {
        case leftTop, rightTop, leftBottom, rightBottom
    }
    func updateBadge(number: Int, type: BadgeType = .dot, position: BadgePosition = .rightTop) {
        guard let subviews = customView?.subviews else {
            print("Badge label container not found.")
            return
        }
        var displayString: String = ""
        var badgeSize: CGSize = .zero
        switch type {
        case .dot:
            badgeSize = number > 0 ? CGSize(width: 10, height: 10) : .zero
        case .number:
            displayString = number > 99 ? "99+" : String(number)
            let displayStringSize = (displayString as NSString).size(withAttributes: [.font:  UIFont.pingFangTCSemibold(ofSize: 12)])
            badgeSize = CGSize(width: displayStringSize.width + 9, height: 17)
        }
        for subview in subviews where subview.accessibilityIdentifier == "Badge" {
            if let badgeLabel = subview as? UILabel {
                badgeLabel.text = displayString
                badgeLabel.widthAnchor.constraint(equalToConstant: badgeSize.width).isActive = true
                badgeLabel.heightAnchor.constraint(equalToConstant: badgeSize.height).isActive = true
                badgeLabel.isHidden = number <= 0
                return
            }
        }
        guard let button = customView as? UIButton,
              number > 0
        else { return }
        
        let badgeLabel: UILabel = UILabel {
            $0.backgroundColor = .red
            $0.clipsToBounds = true
            $0.layer.cornerRadius = badgeSize.height/2
            $0.textColor = .white
            $0.font = UIFont.pingFangTCSemibold(ofSize: 12)
            $0.textAlignment = .center
            $0.text = displayString
            $0.accessibilityIdentifier = "Badge"
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        button.addSubview(badgeLabel)
        switch position {
        case .rightTop:
            badgeLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: (type == .dot) ? 3 : 0).isActive = true
            badgeLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: -3).isActive = true
        case .leftTop:
            badgeLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: (type == .dot) ? -3 : 0).isActive = true
            badgeLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: -3).isActive = true
        case .leftBottom:
            badgeLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: (type == .dot) ? -3 : 0).isActive = true
            badgeLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 3).isActive = true
        case .rightBottom:
            badgeLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: (type == .dot) ? 3 : 0).isActive = true
            badgeLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 3).isActive = true
        }
        badgeLabel.widthAnchor.constraint(equalToConstant: badgeSize.width).isActive = true
        badgeLabel.heightAnchor.constraint(equalToConstant: badgeSize.height).isActive = true
    }
}
