//
//  DropDownView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

typealias Layout = (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)

class DropDownView<T, Cell: UITableViewCell>: NiblessView, UITableViewDelegate, UITableViewDataSource {
    private let dismissableView: UIView = UIView()
    private let tableViewContainerView: UIView = UIView()
    private let tableView: UITableView = UITableView()
    weak var anchorView: UIView?

    var width: CGFloat? {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    var height: CGFloat = 226

    var topInset: CGFloat? {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    private lazy var xConstraint: NSLayoutConstraint = {
        self.tableViewContainerView.leadingAnchor.constraint(equalTo: leadingAnchor)
    }()
    private lazy var yConstraint: NSLayoutConstraint = {
        self.tableViewContainerView.topAnchor.constraint(equalTo: topAnchor)
    }()
    private lazy var widthConstraint: NSLayoutConstraint = {
        self.tableViewContainerView.widthAnchor.constraint(equalToConstant: 0)
    }()
    private lazy var heightConstraint: NSLayoutConstraint = {
        self.tableViewContainerView.heightAnchor.constraint(equalToConstant: 0)
    }()

    var dataSource: [T] = [] {
        didSet {
            DispatchQueue.executeOnMainThread {
                self.tableView.reloadData()
                self.setNeedsUpdateConstraints()
            }
        }
    }

    var cellConfigure: (Cell, T) -> Void
    var selectHandler: (T) -> Void

    init(dataSource: [T], cellConfigure: @escaping (Cell, T) -> Void, selectHandler: @escaping (T) -> Void) {
        self.cellConfigure = cellConfigure
        self.selectHandler = selectHandler
        super.init(frame: .zero)
        constructViewHierarchy()
        activateConstratins()
        tableView.registerCell(Cell.self)
        configTableViewContainerView()
        configTableView()
        backgroundColor = .clear
        dismissableView.backgroundColor = .clear
    }

    func constructViewHierarchy() {
        addSubview(dismissableView)
        tableViewContainerView.addSubview(tableView)
        addSubview(tableViewContainerView)
    }

    func activateConstratins() {
        activateConstraintsDismissableView()
        activateConstraintsTableViewContainerView()
        activateConstraintsTableView()
    }

    private func configTableViewContainerView() {
        tableViewContainerView.backgroundColor = .clear
        tableViewContainerView.layer.cornerRadius = 4
        tableViewContainerView.layer.borderWidth = 1
        tableViewContainerView.layer.borderColor = UIColor.separator.cgColor
        tableViewContainerView.clipsToBounds = true
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DropDownListTableViewCell.self, forCellReuseIdentifier: String(describing: DropDownListTableViewCell.self))
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === dismissableView {
            hide()
            return nil
        } else {
            return view
        }
    }
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        guard let cell = tableView.dequeReusableCell(Cell.self, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        let item = dataSource[indexPath.row]
        cellConfigure(cell, item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = dataSource[indexPath.row]
        selectHandler(item)
    }
}
// MARK: - Actions
extension DropDownView {
    func computeLayout() -> Layout {
        guard let anchorView = anchorView else { return (0, 0, 0, 0) }
        let anchorViewFrameInWindow = anchorView.superview?.convert(anchorView.frame, to: nil)
        let x = anchorViewFrameInWindow?.minX ?? 0
        let y = (anchorViewFrameInWindow?.maxY ?? 0) + (topInset ?? 0)
        let width = self.width ?? (anchorViewFrameInWindow?.width ?? 0)
        let height = self.height
        return (x, y, width, height)
    }

    func show() {
        guard let window = UIWindow.keyWindow else { return }
        window.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true

        let layout = computeLayout()
        xConstraint.constant = layout.x
        yConstraint.constant = layout.y
        widthConstraint.constant = layout.width
        self.layoutIfNeeded()

        self.isHidden = false
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.heightConstraint.constant = layout.height
            self.tableView.flashScrollIndicators()
            self.layoutIfNeeded()
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.heightConstraint.constant = 0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
}
// MARK: - Layouts
extension DropDownView {
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
        NSLayoutConstraint.activate([
            xConstraint, yConstraint, widthConstraint, heightConstraint
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
// MARK: - Drop down list table view cell
class DropDownListTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pingFangTCRegular(ofSize: 14)
        label.textColor = UIColor(hex: "4c4c4c")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initPhase2()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initPhase2()
    }

    private func initPhase2() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        selectionStyle = .gray
    }
}
