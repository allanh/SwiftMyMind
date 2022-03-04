//
//  SKURankingCollectionViewCell.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/13.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

protocol SKURankingCollectionViewCellDelegate: AnyObject {
    func switchContent(type: SKURankingReportList.sevenDaysType, order: SKURankingReport.SKURankingReportSortOrder)
}

class SKURankingCollectionViewCell: UICollectionViewCell {
    
    // 數量或總額
    private weak var delegate: SKURankingCollectionViewCellDelegate?
    private var currentOrder: SKURankingReport.SKURankingReportSortOrder = .TOTAL_SALE_QUANTITY
    private var cellType: SKURankingReportList.sevenDaysType = .commodity {
        didSet {
            headerView.title = cellType.description
        }
    }
    private var rankingList: SKURankingReportList?
    private var setRankingList: SKURankingReportList?
    
    private lazy var dropDownView: DropDownView<SKURankingReport.SKURankingReportSortOrder, DataTypeDropDownListTableViewCell> = {
        let dropDownView = DropDownView(dataSource: SKURankingReport.SKURankingReportSortOrder.allCases) { (cell: DataTypeDropDownListTableViewCell, item) in
            self.configCell(cell: cell, with: item)
        } selectHandler: { item in
            self.selectItem(item: item)
        }
        self.configTableViewContainerView(dropDownView.tableViewContainerView)
        dropDownView.tableViewBackgroundColor = .prussianBlue
        dropDownView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        dropDownView.showScrollBar = false
        dropDownView.topInset = -32
        dropDownView.heightForRow = 32
        dropDownView.height = 76
        dropDownView.shouldReloadItemWhenSelect = true
        return dropDownView
    }()
    
    private lazy var headerView: DropDownHeaderView = {
        let date = "\(Date().sevenDaysBefore.shortDateString) ~ \(Date().yesterday.shortDateString)"
        let view = DropDownHeaderView(frame: .zero,
                                      title: "近7日銷售排行",
                                      alternativeInfo: "銷售數量",
                                      date: date
        )
        view.alternativeInfoViewBackgroundColor = .prussianBlue
        view.titleTextColor = .prussianBlue
        view.dateTextColor = .brownGrey2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = false
        view.isScrollEnabled = false
        view.allowsSelection = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .white
        dropDownView.anchorView = headerView.dropDownView
        constructViewHierarchy()
        activateConstratins()
        configTableView()
        headerView.dropDownView.addTapGesture {
            self.dropDownView.show()
        }
    }
    
    func config(with rankingList: SKURankingReportList?, order: SKURankingReport.SKURankingReportSortOrder) {

    }
    
    func config(type: SKURankingReportList.sevenDaysType, currentOrder: SKURankingReport.SKURankingReportSortOrder, rankingList: SKURankingReportList? = nil, delegate: SKURankingCollectionViewCellDelegate? = nil) {
        self.cellType = type
        self.currentOrder = currentOrder
        self.headerView.alternativeInfo = currentOrder.description
        self.delegate = delegate
        switch cellType {
        case .commodity:
            self.rankingList = rankingList
        case .combined_commodity:
            self.setRankingList = rankingList
        }
        tableView.reloadSections([0], with: .automatic)
    }
}

extension SKURankingCollectionViewCell {
    private func configCell(cell: DataTypeDropDownListTableViewCell,  with item: SKURankingReport.SKURankingReportSortOrder) {
        cell.titleLabel.text = item.description
        cell.titleLabel.textColor = item == currentOrder ? .white : .white.withAlphaComponent(0.65)
        cell.backgroundColor = .clear
    }

    private func selectItem(item: SKURankingReport.SKURankingReportSortOrder) {
        delegate?.switchContent(type: cellType, order: item)
        dropDownView.hide()
    }

    private func configTableViewContainerView(_ view: UIView) {
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 0
        view.clipsToBounds = true
    }
}

extension SKURankingCollectionViewCell {
    private func configTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(SKURankingTableViewCell.self)
    }
    
    func constructViewHierarchy() {
        contentView.addSubview(headerView)
        contentView.addSubview(tableView)
    }
    
    func activateConstratins() {
        activateConstraintsHeaderView()
        activateConstraintsTableView()
    }
    
    func activateConstraintsHeaderView() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-32),
            headerView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func activateConstraintsTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 13),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9)
        ])
    }
}

// MARK: - Table view delegate
extension SKURankingCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellType {
        case .commodity:
            return rankingList?.reports.count ?? 0
        case .combined_commodity:
            return setRankingList?.reports.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(SKURankingTableViewCell.self, for: indexPath) as? SKURankingTableViewCell else {
            fatalError("wrong cell identifier")
        }
        
        var item: SKURankingReport? = nil
        var progress: Float = 0
        switch cellType {
        case .commodity:
            item = rankingList?.reports.getElement(at: indexPath.row)
            progress = rankingList?.getProgress(indexPath.row, sortOrder: currentOrder) ?? 0
        case .combined_commodity:
            item = setRankingList?.reports.getElement(at: indexPath.row)
            progress = setRankingList?.getProgress(indexPath.row, sortOrder: currentOrder) ?? 0
        }
        
        if item != nil {
            cell.config(type: cellType, sortOrder: currentOrder, index: indexPath.row, progress: progress, item: item)
//            cell.construct(with: item, marked: announcementListQueryInfo.title)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AnnouncementViewController") as? AnnouncementViewController {
//            viewController.id = announcementList?.items[indexPath.row].id ?? 0
//            show(viewController, sender: self)
//        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
