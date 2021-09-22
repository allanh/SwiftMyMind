//
//  AnnouncementViewController.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class AnnouncementListViewController: NiblessViewController {
    // MARK: - Properties
    var rootView:  AnnouncementListRootView { view as! AnnouncementListRootView }
    
    var reviewing: Bool 
    
    private lazy var emptyListView: EmptyDataView = {
        return EmptyDataView(frame: rootView.tableView.bounds, icon: "no_announcement", description: "目前尚未有公告訊息", font: .pingFangTCRegular(ofSize: 14), color: .brownGrey)
    }()
    private lazy var filter: AnnouncementListFilterView = {
        return AnnouncementListFilterView(frame: CGRect(x: rootView.bounds.width, y: 0, width: 0, height: rootView.bounds.size.height), model: AnnouncementListFilterModel(queryInfo: announcementListQueryInfo, didUpdateQueryInfo: { info in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.filter.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            } completion: { _ in
                self.filter.removeFromSuperview()
                    self.rootView.organizeOptionView.announcementFilterButton.isSelected = info.isModified
                    self.refreshFetchAnnouncementList(query: self.announcementListQueryInfo)
            }
        }, didCancelUpdate: {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState]) {
                self.filter.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            } completion: { _ in
                self.filter.removeFromSuperview()
            }
        }))
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    lazy var pickSortTypeView: PickSortTypeView<AnnouncementListQueryInfo.AnnouncementOrder, SingleLabelTableViewCell> = {
        if reviewing {
            let pickSortView = PickSortTypeView<AnnouncementListQueryInfo.AnnouncementOrder, SingleLabelTableViewCell>.init(
                dataSource: [AnnouncementListQueryInfo.AnnouncementOrder.STARTED_AT]) { [unowned self] sortType, cell in
                self.configSortCell(cell, item: sortType)
            } cellSelectHandler: { [unowned self] sortType in
                self.didPickSortType(sortType: sortType)
            }
            pickSortView.tableView.separatorStyle = .none
            return pickSortView
        } else {
            let pickSortView = PickSortTypeView<AnnouncementListQueryInfo.AnnouncementOrder, SingleLabelTableViewCell>.init(
                dataSource: AnnouncementListQueryInfo.AnnouncementOrder.allCases) { [unowned self] sortType, cell in
                self.configSortCell(cell, item: sortType)
            } cellSelectHandler: { [unowned self] sortType in
                self.didPickSortType(sortType: sortType)
            }
            pickSortView.tableView.separatorStyle = .singleLine
            return pickSortView
        }
    }()
    private var isPickSortTypeViewViewHierarchyNotReady: Bool = true
    
    let announcementListLoader: AnnouncementListLoader
    
    private var announcementList: AnnouncementList? {
        didSet {
            rootView.tableView.reloadData()
        }
    }
    
    var announcementListQueryInfo: AnnouncementListQueryInfo = .defaultQuery()
    
    private var isNetworkProcessing: Bool = true {
        didSet {
            switch isNetworkProcessing {
            case true: startAnimatingActivityIndicator()
            case false: stopAnimatinActivityIndicator()
            }
        }
    }
    // MARK: - View life cycle
    override func loadView() {
        super.loadView()
        let rootView = AnnouncementListRootView()
        rootView.reviewing = reviewing
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "公告訊息"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.barTintColor = .prussianBlue
        configTableView()
        loadAnnouncementList(query: announcementListQueryInfo)
        addButtonActions()
    }
    
    // MARK: - Method
    init(announcementListLoader: AnnouncementListLoader, reviewing: Bool = false) {
        self.announcementListLoader = announcementListLoader
        self.reviewing = reviewing
        super.init()
    }
    private func configTableView() {
        rootView.tableView.separatorColor = .mercury
        rootView.tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.registerCell(AnnouncementBriefTableViewCell.self)
        
    }
    
    private func configPickSortTypeView() {
        rootView.addSubview(pickSortTypeView)
        pickSortTypeView.translatesAutoresizingMaskIntoConstraints = false
        let top = pickSortTypeView.topAnchor.constraint(equalTo: rootView.topAnchor)
        let leading = pickSortTypeView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor)
        let trailing = pickSortTypeView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor)
        let bottom = pickSortTypeView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor,constant: -80)
        
        NSLayoutConstraint.activate([
            top, leading, trailing, bottom
        ])
    }
    
    private func loadAnnouncementList(query: AnnouncementListQueryInfo? = nil) {
        isNetworkProcessing = true
        announcementListLoader.announcements(with: announcementListQueryInfo).done { announcementList in
            self.handleSucuessFetchAnnouncementList(announcementList)
        }.ensure {
            self.isNetworkProcessing = false
        }.catch(handleErrorForFetchAnnouncementList)
    }
    
    private func handleSucuessFetchAnnouncementList(_ announcementList: AnnouncementList) {
        if self.announcementList != nil {
            self.announcementList?.updateWithNextPageList(announcementList: announcementList)
        } else {
            self.announcementList = announcementList
        }
        announcementListQueryInfo.current = announcementList.currentPageNumber
        announcementListQueryInfo.limit = announcementList.itemsPerPage
        if let announcementList = self.announcementList, announcementList.items.count > 0 {
            emptyListView.removeFromSuperview()
            rootView.tableView.reloadData()
        } else {
            rootView.tableView.addSubview(emptyListView)
        }
    }
    
    private func handleErrorForFetchAnnouncementList(_ error: Error) {
        print(error.localizedDescription)
        if let apiError = error as? APIError {
            _ = ErrorHandler.shared.handle(apiError)
        } else {
            ToastView.showIn(self, message: error.localizedDescription)
        }
    }
    
    private func refreshFetchAnnouncementList(query: AnnouncementListQueryInfo?) {
        query?.current = 1
        announcementList = nil
        loadAnnouncementList(query: query)
    }
    
    private func configSortCell(_ cell: SingleLabelTableViewCell, item: AnnouncementListQueryInfo.AnnouncementOrder) {
        cell.titleLabel.text = item.description
        let isSelected = self.announcementListQueryInfo.order == item
        cell.titleLabel.textColor = isSelected ? .prussianBlue : .veryDarkGray
    }
    
    private func didPickSortType(sortType: AnnouncementListQueryInfo.AnnouncementOrder) {
        announcementListQueryInfo.order = sortType
        refreshFetchAnnouncementList(query: announcementListQueryInfo)
        rootView.organizeOptionView.announcementSortButton.setTitle(sortType.description, for: .normal)
        pickSortTypeView.hide()
    }
    
    private func addButtonActions() {
     //   rootView.organizeOptionView.announcementSortButton.addTarget(self, action: #selector(sortButtonDidTapped(_:)), for: .touchUpInside)
        rootView.organizeOptionView.announcementFilterButton.addTarget(self, action: #selector(filterButtonDidTapped), for: .touchUpInside)
        rootView.organizeOptionView.annoucementIsTopButton.addTarget(self, action: #selector(isTopButtonDidTapped(_:)), for: .touchUpInside)
        rootView.organizeOptionView.announcementSortButton.addTarget(self, action: #selector(sortButtonColorDidTapped(_:)), for: .touchUpInside)
    }
    
    @objc
    private func sortButtonDidTapped(_ sender: UIButton) {
        if isPickSortTypeViewViewHierarchyNotReady {
            configPickSortTypeView()
            view.layoutIfNeeded()
            isPickSortTypeViewViewHierarchyNotReady = false
        }
        switch pickSortTypeView.isHidden {
        case true: pickSortTypeView.show()
        case false: pickSortTypeView.hide()
        }
    }
    
    @objc
    private func filterButtonDidTapped(_ sender: UIButton) {
        filter.frame = CGRect(x: view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(filter)
//        filter.delegate = self
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.filter.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        } completion: { _ in
            print("done")
        }
    }
    @objc
    private func isTopButtonDidTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let isTopButton = rootView.organizeOptionView.annoucementIsTopButton
        if  isTopButton.isSelected == true {
            isTopButton.layer.borderWidth = 1
            isTopButton.layer.borderColor = UIColor.prussianBlue.cgColor
            isTopButton.backgroundColor = UIColor(hex: "f1f8fe")
            announcementListQueryInfo.top = true
        } else {
            isTopButton.backgroundColor = .veryLightPink
            isTopButton.layer.borderWidth = 0
            announcementListQueryInfo.top = nil
        }
        refreshFetchAnnouncementList(query: announcementListQueryInfo)
    }
    @objc
    private func sortButtonColorDidTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let sortButton = rootView.organizeOptionView.announcementSortButton
        if  sortButton.isSelected == true {
            announcementListQueryInfo.sort = .ascending
        } else {
            announcementListQueryInfo.sort = .decending
        }
        refreshFetchAnnouncementList(query: announcementListQueryInfo)
    }

}
// MARK: - Table view delegate
extension AnnouncementListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementList?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(AnnouncementBriefTableViewCell.self, for: indexPath) as? AnnouncementBriefTableViewCell else {
            fatalError("wrong cell identifier")
        }
        if let item = announcementList?.items[indexPath.row] {
            cell.construct(with: item, marked: announcementListQueryInfo.title)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AnnouncementViewController") as? AnnouncementViewController {
            viewController.id = announcementList?.items[indexPath.row].id ?? 0
            show(viewController, sender: self)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
//extension AnnouncementListViewController: AnnouncementListFilterViewDelegate {
//    func didCancelFilter(_ view: AnnouncementListFilterView) {
//        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState]) {
//            self.filter.frame = CGRect(x: self.view.bounds.width, y: 0, width: view.bounds.width, height: self.view.bounds.height)
//        } completion: { _ in
//            self.filter.removeFromSuperview()
//        }
//    }
//
//    func filterView(_ view: AnnouncementListFilterView, didFilterWith info: AnnouncementListQueryInfo) {
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
//            self.filter.frame = CGRect(x: self.view.bounds.width, y: 0, width: view.bounds.width, height: self.view.bounds.height)
//        } completion: { _ in
//            self.filter.removeFromSuperview()
//                self.rootView.organizeOptionView.announcementFilterButton.isSelected = info.isModified
//                self.refreshFetchAnnouncementList(query: self.announcementListQueryInfo)
//        }
//    }
//}
