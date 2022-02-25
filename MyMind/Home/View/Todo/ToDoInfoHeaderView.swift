//
//  ToDoInfoHeaderView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/10.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class ToDoInfoHeaderView: NiblessView {
    enum HeaderType {
        case TAB, POPUP
    }
    
    var type: HeaderType = .TAB
    var hierarchyNotReady: Bool = true
    var toDo: ToDo? = nil {
        didSet {
            if let item = toDo {
                backgroundView.image = UIImage(named: type == .TAB ? item.type.imageName : item.type.popupImageName)
                titleLabel.text = item.type.displayName
                totalLabel.text = item.items.sum(\.count).toDecimalString()
            }
        }
    }
    
    init(frame: CGRect, type: HeaderType) {
        self.type = type
        super.init(frame: frame)
    }
    
    private let backgroundView: UIImageView = UIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
    }

    private let totalLabel: UILabel = UILabel {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.sizeToFit()
        $0.textColor = .white
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
        switch type {
        case .TAB:
            titleLabel.font = .pingFangTCSemibold(ofSize: 14)
            totalLabel.font = .pingFangTCSemibold(ofSize: 24)
        case .POPUP:
            titleLabel.font = .pingFangTCSemibold(ofSize: 16)
            totalLabel.font = .pingFangTCSemibold(ofSize: 28)
        }
        
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
        let top = titleLabel.topAnchor
            .constraint(equalTo: topAnchor, constant: type == .TAB ? 16 : 36)
        let trailing = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16)
        let leading = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: type == .TAB ? 24 : 32)

        NSLayoutConstraint.activate([
            top, leading, trailing
        ])
    }

    private func activateConstraintsTotalLabel() {
        let top = totalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)
        let leading = totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: type == .TAB ? 24 : 32)

        NSLayoutConstraint.activate([
            top, leading
        ])
    }
}
