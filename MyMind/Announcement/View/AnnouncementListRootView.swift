//
//  AnnouncementListRootView.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class AnnouncementListRootView: NiblessView {
    
    // var reviewing: Bool = false
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.sectionHeaderHeight = .leastNormalMagnitude
        return tableView
    }()
    
    lazy var organizeOptionView: OrganizeOptionView = {
        let optionView = OrganizeOptionView()
        
     //   optionView.displayType = [.sort, .filter]
        optionView.setupForAnnouncement()
        return optionView
    }()
    
    private var hierarchyNotReady: Bool = true
    
    var reviewing: Bool = false
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else { return }
        
        constructViewHierarchy()
        activateConstraints()
        hierarchyNotReady = false
    }
    // 建立 Tabel view & organizeOption view
    func constructViewHierarchy() {
        addSubview(tableView)
        addSubview(organizeOptionView)
    }
    // 建立所有的 constraints
    func activateConstraints() {
        activeConstraintsTableView()
        activeConstraintsOptionOrganizeOptionView()
    }
    
}
// MARK: - Layouts
private extension AnnouncementListRootView {
    // Table View constraints
    private func activeConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = tableView.topAnchor.constraint(equalTo: organizeOptionView.bottomAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])

    }
    // OrganizeOptionview constraints
    private func activeConstraintsOptionOrganizeOptionView() {
        organizeOptionView.translatesAutoresizingMaskIntoConstraints = false
        let top = organizeOptionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = organizeOptionView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = organizeOptionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        let height = organizeOptionView.heightAnchor.constraint(equalToConstant: 48)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, height
        ])
    }
    
}
