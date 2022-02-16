//
//  ToDoCardCollectionViewCell.swift
//  MyMind
//
//  Created by Shih Allan on 2022/1/26.
//  Copyright © 2022 United Digital Intelligence. All rights reserved.
//

import UIKit

class ToDoCardCollectionViewCell: UICollectionViewCell {

    private var todo: ToDo? {
        didSet {
            tableView.reloadData()
        }
    }
    private var headerView: ToDoInfoHeaderView = {
        let view = ToDoInfoHeaderView(frame: .zero, type: .POPUP)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let itemView: ToDoItemView = {
        let view = ToDoItemView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = 32
        view.register(ToDoCardTableViewCell.self, forCellReuseIdentifier: String(describing: ToDoCardTableViewCell.self))
        view.isScrollEnabled = false
        view.layer.cornerRadius = 8
        
        view.drawBorder(edges: [.left, .right, .bottom], borderWidth: 1, color: .tertiaryLabel)
        view.contentInset = .init(top: 12, left: 0, bottom: 12, right: 0)
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
        self.todo = todo
        headerView.toDo = todo
    }
    
    private func constructViewHierarchy() {
        contentView.addSubview(headerView)
        tableView.dataSource = self
        tableView.delegate = self
        contentView.addSubview(tableView)
    }

    private func activateConstraints() {
        activateConstraintsHeaderView()
        activateConstraintsTableView()
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
    
    private func activateConstraintsTableView() {
        let leading = tableView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
        let trailing = tableView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
        let top = tableView.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 124)
        let bottom = tableView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)

        NSLayoutConstraint.activate([
            leading, trailing, top, bottom
        ])
    }
}

// MARK: - Table view data source
extension ToDoCardCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        guard let cell = tableView.dequeReusableCell(ToDoCardTableViewCell.self, for: indexPath) as? ToDoCardTableViewCell else {
            return UITableViewCell()
        }
        
        if let item = todo?.items.getElement(at: indexPath.row) {
            cell.titleLabel.text = item.type.displayName
            cell.valueLabel.text = item.count.toDecimalString()
        }
        return cell
    }
}

// MARK: - Table view delegate
extension ToDoCardCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - Todo list table view cell
class ToDoCardTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTCRegular(ofSize: 16)
        label.textColor = .brownGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTCRegular(ofSize: 16)
        label.textColor = .emperor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configTableView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configTableView()
    }
    
    private func configTableView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 32),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
