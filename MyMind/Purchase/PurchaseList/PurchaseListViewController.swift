//
//  PurchaseListViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class PurchaseListViewController: NiblessViewController {
    // MARK: - Properties
    var rootView: PurchaseListRootView { view as! PurchaseListRootView }

    lazy var pickSortTypeView: PickSortTypeView<PurchaseListQueryInfo.OrderReference, SingleLabelTableViewCell> = {
        let pickSortView = PickSortTypeView<PurchaseListQueryInfo.OrderReference, SingleLabelTableViewCell>.init(
            dataSource: PurchaseListQueryInfo.OrderReference.allCases) { [unowned self] sortType, cell in
            self.configSortCell(cell, item: sortType)
        } cellSelectHandler: { [unowned self] sortType in
            self.didPickSortType(sortType: sortType)
        }
        pickSortView.tableView.separatorStyle = .none
        return pickSortView
    }()
    private var isPickSortTypeViewViewHierarchyNotReady: Bool = true

    let purchaseListLoader: PurchaseListLoader

    private var purchaseList: PurchaseList?

    var purchaseListQueryInfo: PurchaseListQueryInfo = .defaultQuery()

    /// Must set on main thread
    private var isNetworkProcessing: Bool = false {
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

        view = PurchaseListRootView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "採購申請單列表"
        addCloseButton()
        configTableView()
        configCollectionView()
        loadPurchaseList()
        addButtonsActions()
    }
    // MARK: - Methods
    init(purchaseListLoader: PurchaseListLoader) {
        self.purchaseListLoader = purchaseListLoader
        super.init()
    }

    private func addCloseButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidTapped(_:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }

    private func configPickSortTypeView() {
        rootView.addSubview(pickSortTypeView)
        pickSortTypeView.translatesAutoresizingMaskIntoConstraints = false
        let top = pickSortTypeView.topAnchor
            .constraint(equalTo: rootView.topAnchor)
        let leading = pickSortTypeView.leadingAnchor
            .constraint(equalTo: rootView.leadingAnchor)
        let bottom = pickSortTypeView.bottomAnchor
            .constraint(equalTo: rootView.organizeOptionView.topAnchor)
        let trailing = pickSortTypeView.trailingAnchor
            .constraint(equalTo: rootView.trailingAnchor)

        NSLayoutConstraint.activate([
            top, leading, bottom, trailing
        ])
    }

    private func configTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.registerCell(PurchaseBriefTableViewCell.self)
    }

    private func configCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        rootView.collectionView.registerCellFormNib(for: PurchaseBriefCollectionViewCell.self)
    }

    private func addButtonsActions() {
        rootView.organizeOptionView.sortButton.addTarget(self, action: #selector(sortButtonDidTapped(_:)), for: .touchUpInside)
        rootView.organizeOptionView.layoutButton.addTarget(self, action: #selector(layoutButtonDidTapped(_:)), for: .touchUpInside)
        rootView.organizeOptionView.filterButton.addTarget(self, action: #selector(filterButtonDidTapped(_:)), for: .touchUpInside)
        rootView.createButton.addTarget(self, action: #selector(createButtonDidTapped(_:)), for: .touchUpInside)
    }

    private func loadPurchaseList(purchaseListQueryInfo: PurchaseListQueryInfo? = nil) {
        isNetworkProcessing = true
        purchaseListLoader.loadPurchaseList(with: purchaseListQueryInfo)
            .done { purchaseList in
                self.handleSuccessFetchPurchaseList(purchaseList)
            }
            .ensure {
                self.isNetworkProcessing = false
            }
            .catch(handleErrorForFetchPurchaseList(_:))
    }

    private func refreshFetchPurchaseList(query: PurchaseListQueryInfo?) {
        var refreshQuery = query
        refreshQuery?.pageNumber = 1
        purchaseList = nil
        loadPurchaseList(purchaseListQueryInfo: refreshQuery)
    }

    private func handleSuccessFetchPurchaseList(_ purchaseList: PurchaseList) {
        if self.purchaseList != nil {
            self.purchaseList?.updateWithNextPageList(purchaseList: purchaseList)
        } else {
            self.purchaseList = purchaseList
        }
        purchaseListQueryInfo.updateCurrentPageInfo(with: purchaseList)
        rootView.tableView.reloadData()
        rootView.collectionView.reloadData()
    }

    private func handleErrorForFetchPurchaseList(_ error: Error) {
        #warning("Error handling")
        print(error.localizedDescription)
    }

    private func configSortCell(_ cell: SingleLabelTableViewCell, item: PurchaseListQueryInfo.OrderReference) {
        cell.titleLabel.text = item.description
        let isSelected = self.purchaseListQueryInfo.orderReference == item
        let textColor = isSelected ? UIColor(hex: "004477") : UIColor(hex: "4c4c4c")
        cell.titleLabel.textColor = textColor
    }

    private func didPickSortType(sortType: PurchaseListQueryInfo.OrderReference) {
        purchaseListQueryInfo.orderReference = sortType
        refreshFetchPurchaseList(query: purchaseListQueryInfo)
        rootView.organizeOptionView.sortButton.setTitle(sortType.description, for: .normal)
        pickSortTypeView.hide()
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
    private func layoutButtonDidTapped(_ sender: UIButton) {
        rootView.collectionView.isHidden.toggle()
        rootView.tableView.isHidden.toggle()
        let imageName = rootView.collectionView.isHidden ? "list" : "grid"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }

    @objc
    private func filterButtonDidTapped(_ sender: UIButton) {
        let viewModel = PurchaseListFilterViewModel(
            service: MyMindAutoCompleteAPIService(userSessionDataStore: KeychainUserSessionDataStore()),
            queryInfo: purchaseListQueryInfo) { [weak self] queryInfo in
            self?.purchaseListQueryInfo = queryInfo
            self?.refreshFetchPurchaseList(query: queryInfo)
        }
        let viewController = PurchaseListFilterViewController(viewModel: viewModel)

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    @objc
    private func createButtonDidTapped(_ sender: UIButton) {
        let adapter = VendorInfoAdapter(service: MyMindAutoCompleteAPIService(userSessionDataStore: KeychainUserSessionDataStore()))
        let viewController = PickVendorViewController(loader: adapter)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func closeButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - Scroll view delegate
extension PurchaseListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isNetworkProcessing == false,
              let purchaseList = purchaseList,
              scrollView.isDragging
        else { return }

        let currentScrolledHeight = scrollView.frame.height + scrollView.contentOffset.y
        let currentScrolledPercentage = currentScrolledHeight / scrollView.contentSize.height
        let threshold: CGFloat = 0.8

        if currentScrolledPercentage > threshold,
           purchaseListQueryInfo.updatePageNumberForNextPage(with: purchaseList) {
            loadPurchaseList(purchaseListQueryInfo: purchaseListQueryInfo)
        }
    }
}
// MARK: - Table view delegate
extension PurchaseListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseList?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(PurchaseBriefTableViewCell.self, for: indexPath) as? PurchaseBriefTableViewCell else {
            fatalError("Worng cell identifier")
        }
        if let purchaseBrief = purchaseList?.items[indexPath.row] {
            cell.config(with: purchaseBrief)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
// MARK: - Collection view delegate
extension PurchaseListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purchaseList?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(PurchaseBriefCollectionViewCell.self, for: indexPath) as? PurchaseBriefCollectionViewCell else {
            fatalError("Please register cell first or wrong identifier")
        }
        if let purchaseBrief = purchaseList?.items[indexPath.item] {
            cell.config(with: purchaseBrief)
        }
        return cell
    }
}
// MARK: - Collection view flow layout
extension PurchaseListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var horizontalSpace: CGFloat = 0
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            horizontalSpace = layout.minimumLineSpacing + layout.sectionInset.left + layout.sectionInset.right
        }
        let width = (collectionView.frame.width - horizontalSpace) / 2
        return CGSize(width: width, height: 280)
    }
}
