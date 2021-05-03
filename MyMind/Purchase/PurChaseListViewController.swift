//
//  PurChaseListViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class PurchaseListViewController: NiblessViewController {

    var rootView: PurchaseListRootView { view as! PurchaseListRootView }

    let purchaseAPIService: PurchaseAPIService
    var purchaseList: PurchaseList?
    var purchaseListQueryInfo: PurchaseListQueryInfo =  .defaultQueryInfo(for: "3")

    /// Must set on main thread
    private var isNetworkProcessing: Bool = false {
        didSet {
            switch isNetworkProcessing {
            case true: startAnimatingActivityIndicator()
            case false: stopAnimatinActivityIndicator()
            }
        }
    }

    init(purchaseAPIService: PurchaseAPIService) {
        self.purchaseAPIService = purchaseAPIService
        super.init()
    }

    override func loadView() {
        super.loadView()
        view = PurchaseListRootView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configTableView()
        fetchPurchaseList(with: "3")
    }

    private func configTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.registerCell(PurchaseBriefTableViewCell.self)
    }

    private func fetchPurchaseList(
        with partherID: String,
        purchaseListQueryInfo: PurchaseListQueryInfo? = nil) {
        isNetworkProcessing = true
        purchaseAPIService.fetchPurchaseList(with: partherID, purchaseListQueryInfo: purchaseListQueryInfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let purchaseList):
                if self.purchaseList != nil {
                    self.purchaseList?.updateWithNextPageList(purchaseList: purchaseList)
                } else {
                    self.purchaseList = purchaseList
                }
                self.purchaseListQueryInfo.updateCurrentPageInfo(with: purchaseList)
                DispatchQueue.main.async {
                    self.rootView.tableView.reloadData()
                    self.isNetworkProcessing = false
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isNetworkProcessing = false
                }
            }
        }
    }
}

extension PurchaseListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isNetworkProcessing == false,
              let purchaseList = purchaseList
        else { return }

        let currentScrolledHeight = scrollView.frame.height + scrollView.contentOffset.y
        let currentScrolledPercentage = currentScrolledHeight / scrollView.contentSize.height
        let threshold: CGFloat = 0.7

        if currentScrolledPercentage > threshold,
           purchaseListQueryInfo.updatePageNumberForNextPage(with: purchaseList) {
            fetchPurchaseList(with: purchaseListQueryInfo.partnerID, purchaseListQueryInfo: purchaseListQueryInfo)
        }
    }
}

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
