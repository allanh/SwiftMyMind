//
//  PickSortTypeView.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PickSortTypeView<T, Cell: UITableViewCell>: NiblessView, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    private let dismissableView: UIView = UIView {
        $0.backgroundColor = .clear
    }
    
    private let tableViewContainerView: UIView = UIView {
        $0.backgroundColor = .white
    }

    let tableView: UITableView = UITableView {
        $0.backgroundColor = .white
    }

    lazy var tableViewContainerViewHeightConstraints: NSLayoutConstraint = tableViewContainerView.heightAnchor.constraint(equalToConstant: 0)
    private var hierarchyNotReady: Bool = true

    var dataSource: [T] {
        didSet {
            tableView.reloadData()
        }
    }
    let cellConfiguration: (T, Cell) -> Void
    let cellSelectHandler: (T) -> Void
    var cellHeight: CGFloat = 36

    init(frame: CGRect = .zero,
         dataSource: [T],
         cellConfiguration: @escaping (T, Cell) -> Void,
         cellSelectHandler: @escaping (T) -> Void) {
        self.dataSource = dataSource
        self.cellConfiguration = cellConfiguration
        self.cellSelectHandler = cellSelectHandler
        super.init(frame: frame)
        configTableView()
        isHidden = true
        backgroundColor = .clear
    }
    // MARK: - Methods
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else { return }
        constructViewHierarchy()
        activateConstraints()
        addDisMissGestureToDismissableView()
        hierarchyNotReady = false
    }

    private func constructViewHierarchy() {
        addSubview(dismissableView)
        tableViewContainerView.addSubview(tableView)
        addSubview(tableViewContainerView)
    }

    private func activateConstraints() {
        activateConstraintsDismissableView()
        activateConstraintsTableViewContainerView()
        activateConstraintsTableView()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(Cell.self)
    }

    func reloadContent() {
        tableView.reloadData()
    }

    private func addDisMissGestureToDismissableView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        dismissableView.addGestureRecognizer(gesture)
    }

    func show() {
        guard isHidden else { return }
        self.isHidden = false

        tableViewContainerViewHeightConstraints.constant = cellHeight * CGFloat(dataSource.count)
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.layoutIfNeeded()
        }
    }

    @objc
    func hide() {
        guard isHidden == false else { return }

        tableViewContainerViewHeightConstraints.constant = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.backgroundColor = .clear
            self.layoutIfNeeded()
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.isHidden = true
        }
    }
    // MARK: - Table view data source and delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(Cell.self, for: indexPath) as? Cell else {
            print("----Wrong cell identifier or not register cell yet----")
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let item = dataSource[indexPath.item]
        cellConfiguration(item, cell)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.item]
        cellSelectHandler(item)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
// MARK: - Layouts
extension PickSortTypeView {
    private func activateConstraintsDismissableView() {
        dismissableView.translatesAutoresizingMaskIntoConstraints = false
        let top = dismissableView.topAnchor
            .constraint(equalTo: topAnchor)
        let leading = dismissableView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = dismissableView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
        let trailing = dismissableView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }
    private func activateConstraintsTableViewContainerView() {
        tableViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        let leading = tableViewContainerView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = tableViewContainerView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
        let trailing = tableViewContainerView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, tableViewContainerViewHeightConstraints
        ])
    }

    private func activateConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = tableView.topAnchor
            .constraint(equalTo: tableViewContainerView.topAnchor)
        let leading = tableView.leadingAnchor
            .constraint(equalTo: tableViewContainerView.leadingAnchor)
        let bottom = tableView.bottomAnchor
            .constraint(equalTo: tableViewContainerView.bottomAnchor)
        let trailing = tableView.trailingAnchor
            .constraint(equalTo: tableViewContainerView.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }
}
