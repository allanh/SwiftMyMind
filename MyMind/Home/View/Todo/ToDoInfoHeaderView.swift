//
//  ToDoInfoHeaderView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class ToDoInfoHeaderView: NiblessView {
    enum BackgroundType {
        case BACKGROUND, POPUP
    }
    
    var backgroundType: BackgroundType = .BACKGROUND
    var hierarchyNotReady: Bool = true
    var toDo: ToDo? = nil {
        didSet {
            if let item = toDo {
                backgroundView.image = UIImage(named: backgroundType == .BACKGROUND ? item.type.imageName : item.type.popupImageName)
                titleLabel.text = item.type.displayName
                totalLabel.text = String(item.items.sum(\.count))
            }
        }
    }
    
    init(frame: CGRect, backgroundType: BackgroundType) {
        self.backgroundType = backgroundType
        super.init(frame: frame)
    }
    
    private let backgroundView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = .pingFangTCSemibold(ofSize: 14)
    }

    private let totalLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = .pingFangTCSemibold(ofSize: 24)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else {
          return
        }
        arrangeView()
        activateConstraints()
        hierarchyNotReady = false
    }
}

/// helper
extension ToDoInfoHeaderView {
    private func arrangeView() {
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(totalLabel)
    }
    private func activateConstraints() {
        activateConstraintsBackgroundView()
        activateConstraintsTitleLabel()
        activateConstraintsTotalLabel()
    }
}

/// constraints
extension ToDoInfoHeaderView {
    private func activateConstraintsBackgroundView() {
        let top = backgroundView.topAnchor.constraint(equalTo: topAnchor)
        let leading = backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }

    private func activateConstraintsTitleLabel() {
        let top = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        let trailing = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16)
        let leading = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)

        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }

    private func activateConstraintsTotalLabel() {
        let top = totalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)
        let leading = totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }
}
