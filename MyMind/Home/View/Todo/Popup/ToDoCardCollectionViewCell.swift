//
//  ToDoCardCollectionViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2022/1/26.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import UIKit

class ToDoCardCollectionViewCell: UICollectionViewCell {

    private var headerView: ToDoInfoHeaderView = {
        let view = ToDoInfoHeaderView(frame: .zero, backgroundType: .POPUP)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let itemView: ToDoItemView = {
        let view = ToDoItemView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViewHierarchy()
        activateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with todo: ToDo) {
        headerView.toDo = todo
        itemView.item = todo.items.getElement(at: 0)
    }
    
    private func constructViewHierarchy() {
        contentView.addSubview(headerView)
        contentView.addSubview(itemView)
    }

    private func activateConstraints() {
        activateConstraintsHeaderView()
        activateConstraintsItemView()
    }
}

// MARK: - Layouts

extension ToDoCardCollectionViewCell {
    private func activateConstraintsHeaderView() {
        let leading = headerView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let trailing = headerView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let top = headerView.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 8)
        let height = headerView.heightAnchor.constraint(equalToConstant: 124)

        NSLayoutConstraint.activate([
            leading, trailing, top, height
        ])
    }
    
    private func activateConstraintsItemView() {
        let leading = itemView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let trailing = itemView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let top = itemView.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 106)
        let bottom = itemView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)

        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
}
