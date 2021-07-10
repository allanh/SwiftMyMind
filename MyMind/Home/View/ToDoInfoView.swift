//
//  ToDoInfoView.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class ToDoInfoView: NiblessView {
    var hierarchyNotReady: Bool = true
    let toDo: ToDo
    init(frame: CGRect, toDo: ToDo) {
        self.toDo = toDo
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.tertiaryLabel.cgColor
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
          return
        }
        constructViews()
        arrangeView()
        activateConstraints()
        backgroundColor = .systemBackground
        hierarchyNotReady = false
    }
    private var headerView: ToDoInfoHeaderView!
    var itemViews: [ToDoItemView] = []
}
/// helper
extension ToDoInfoView {
    private func constructViews() {
        headerView = ToDoInfoHeaderView(frame: bounds, toDo: toDo)
        for index in 0..<toDo.items.count {
            itemViews.append(ToDoItemView(frame: .zero, item: toDo.items[index]))
        }
    }
    private func arrangeView() {
        addSubview(headerView)
        for index in 0..<itemViews.count {
            addSubview(itemViews[index])
        }
    }
    private func activateConstraints() {
        activateConstraintsHeaderView()
        activateConstraintsItemViews()
    }
}
/// constraints
extension ToDoInfoView {
    private func activateConstraintsHeaderView() {
        let top = headerView.topAnchor
            .constraint(equalTo: topAnchor, constant: 8)
        let height = headerView.heightAnchor
            .constraint(equalToConstant: 56)
        let leading = headerView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 8)
        let trailing = headerView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -8)

        NSLayoutConstraint.activate([
            top, height, leading, trailing
        ])
    }
    private func activateConstraintsItemViews() {
        var offsetY: CGFloat = 56
        for index in 0..<itemViews.count {
            let leading = itemViews[index].leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 8)
            let trailing = itemViews[index].trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -8)
            let top = itemViews[index].topAnchor
                .constraint(equalTo: topAnchor, constant: 16+offsetY)
            let width = itemViews[index].widthAnchor
                .constraint(equalTo: widthAnchor, multiplier: 0.45)
            let height = itemViews[index].heightAnchor
                .constraint(equalTo: heightAnchor, multiplier: 0.3)
            if index % 2 == 0 {
                NSLayoutConstraint.activate([
                    leading, top, width, height
                ])
            } else {
                NSLayoutConstraint.activate([
                    trailing, top, width, height
                ])
                offsetY += (self.bounds.height*0.3)
                offsetY += 16
                
            }
        }
    }
}
