//
//  PurchaseListRootView.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class PurchaseListRootView: NiblessView {

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

    let createButton: UIButton = UIButton {
        $0.setImage(UIImage(named: "plus"), for: .normal)
        $0.backgroundColor = UIColor(hex: "004477")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }

    let organizeOptionView: OrganizeOptionView = OrganizeOptionView()

    private var hierarchyNotReady: Bool = true

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
        addSubview(createButton)
    }

    func activateConstraints() {
        activateConstraintsCollecitonView()
        activateConstraintsTableView()
        activateConstraintsOrganizeOptionView()
        activateConstraintsCreatButton()
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

    private func activateConstraintsCreatButton() {
        createButton.translatesAutoresizingMaskIntoConstraints = false
        let trailing = createButton.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -15)
        let bottom = createButton.bottomAnchor
            .constraint(equalTo: organizeOptionView.topAnchor, constant: -15)
        let width = createButton.widthAnchor
            .constraint(equalToConstant: 40)
        let height = createButton.heightAnchor
            .constraint(equalTo: createButton.widthAnchor)

        NSLayoutConstraint.activate([
            trailing, bottom, width, height
        ])
    }
}
