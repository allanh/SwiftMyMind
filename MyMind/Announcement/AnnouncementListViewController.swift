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
        return EmptyDataView(frame: rootView.tableView.bounds)
    }()
    
    lazy var pickSortTypeView: PickSortTypeView<AnnouncementListQueryInfo.OrderReference, SingleLabelTableViewCell> = {
        if reviewing {
            let pickSortView = PickSortTypeView<AnnouncementListQueryInfo.OrderReference, SingleLabelTableViewCell>.init(
                dataSource: [AnnouncementListQueryInfo.OrderReference.startedAt]) { [unowned self] sortType, cell in
                self.configSortCell(cell, item: sortType)
            } cellSelectHandler: { [unowned self] sortType in
                self.didPickSortType(sortType: sortType)
            }
            pickSortView.tableView.separatorStyle = .none
            return pickSortView
        } else {
            let pickSortView = PickSortTypeView<AnnouncementListQueryInfo.OrderReference, SingleLabelTableViewCell>.init(
                dataSource: AnnouncementListQueryInfo.OrderReference.allCases) { [unowned self] sortType, cell in
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
    
    private var announcementList: AnnouncementList?
    
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
        configTableView()
        loadAnnouncementList(announcementListQueryInfo: announcementListQueryInfo)
        addButtonActions()
    }
    
    // MARK: - Method
    init(announcementListLoader: AnnouncementListLoader, reviewing: Bool = false) {
        self.announcementListLoader = announcementListLoader
        self.reviewing = reviewing
        super.init()
    }
    private func configTableView() {
        rootView.tableView.separatorColor = .black
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
    
    private func loadAnnouncementList(announcementListQueryInfo: AnnouncementListQueryInfo? = nil) {
        isNetworkProcessing = true
        announcementListLoader.loadAnnouncementList(with: announcementListQueryInfo).done { announcementList in
            self.handleSucuessFetchAnnouncementList(announcementList)
        }.ensure {
            self.isNetworkProcessing = false
        }
//         .catch(handleErrorForFetchAnnouncementList)
    }
    
    private func handleSucuessFetchAnnouncementList(_ announcementList: AnnouncementList) {
        if self.announcementList != nil {
            self.announcementList?.updateWithNextPageList(announcementList: announcementList)
        } else {
            self.announcementList = announcementList
        }
        announcementListQueryInfo.updateCurrentPageInfo(with: announcementList)
        if self.announcementList?.items.count == 0 {
            rootView.tableView.addSubview(emptyListView)
        } else {
            emptyListView.removeFromSuperview()
            rootView.tableView.reloadData()
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
        var refreshQuery = query
        refreshQuery?.pageNumber = 1
        announcementList = nil
        loadAnnouncementList(announcementListQueryInfo: refreshQuery)
    }
    
    private func configSortCell(_ cell: SingleLabelTableViewCell, item: AnnouncementListQueryInfo.OrderReference) {
        cell.titleLabel.text = item.description
        let isSelected = self.announcementListQueryInfo.orderReference == item
        let textColor = isSelected ? UIColor(hex: "004477") : UIColor(hex: "4c4c4c")
        cell.titleLabel.textColor = textColor
    }
    
    private func didPickSortType(sortType: AnnouncementListQueryInfo.OrderReference) {
        announcementListQueryInfo.orderReference = sortType
        refreshFetchAnnouncementList(query: announcementListQueryInfo)
        rootView.organizeOptionView.announcementSortButton.setTitle(sortType.description, for: .normal)
        pickSortTypeView.hide()
    }
    
    private func addButtonActions() {
        rootView.organizeOptionView.announcementSortButton.addTarget(self, action: #selector(sortButtonDidTapped(_:)), for: .touchUpInside)
        rootView.organizeOptionView.announcementFilterButton.addTarget(self, action: #selector(filterButtonDidTapped), for: .touchUpInside)
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
        let viewModel = AnnouncementFilterViewModel(service: MyMindAutoCompleteAPIService(userSessionDataStore: KeychainUserSessionDataStore()), queryInfo: announcementListQueryInfo) { [ weak self] queryInfo in
            self?.announcementListQueryInfo = queryInfo
            self?.refreshFetchAnnouncementList(query: queryInfo)
        }
        let viewController = AnnouncementListFilterViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
}
// MARK: - Table view delegate
extension AnnouncementListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(AnnouncementBriefTableViewCell.self, for: indexPath) as? AnnouncementBriefTableViewCell else {
            fatalError("wrong cell identifier")
        }
        cell.construct()
        return cell
    }
    
    
}
