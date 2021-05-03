//
//  PurchaseListRootView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class PurchaseListRootView: NiblessView {
    private var hierarchyNotReady: Bool = true

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = .init(top: 15, left: 10, bottom: 15, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.backgroundColor = .white
        return collectionView
    }()

    let organizeOptionView: OrganizeOptionView = OrganizeOptionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else { return }
        constructViewHierarchy()
        activateConstraints()
        hierarchyNotReady = false
    }

    func constructViewHierarchy() {
        addSubview(collectionView)
        addSubview(tableView)
        addSubview(organizeOptionView)
    }

    func activateConstraints() {
        activateConstraintsCollecitonView()
        activateConstraintsTableView()
        activateConstraintsOrganizeOptionView()
    }
}
// MARK: - Layouts
private extension PurchaseListRootView {
    private func activateConstraintsCollecitonView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let top = collectionView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = collectionView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = collectionView.bottomAnchor
            .constraint(equalTo: organizeOptionView.topAnchor)
        let trailing = collectionView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func activateConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = tableView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = tableView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = tableView.bottomAnchor
            .constraint(equalTo: organizeOptionView.topAnchor)
        let trailing = tableView.trailingAnchor
            .constraint(equalTo: trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func activateConstraintsOrganizeOptionView() {
        organizeOptionView.translatesAutoresizingMaskIntoConstraints = false
        let leading = organizeOptionView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
        let bottom = organizeOptionView.bottomAnchor
            .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        let trailing = organizeOptionView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
        let height = organizeOptionView.heightAnchor
            .constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([
            leading, bottom, trailing, height
        ])
    }
}
