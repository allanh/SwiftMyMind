//
//  PurChaseListViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/29.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

final class PurchaseListViewController: NiblessViewController {

    var rootView: PurchaseListRootView { view as! PurchaseListRootView }

    let purchaseAPIService: PurchaseAPIService
    var purchaseList: PurchaseList?
    var purchaseListQueryInfo: PurchaseListQueryInfo =  .defaultQueryInfo(for: "3")

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
        purchaseAPIService.fetchPurchaseList(with: partherID, purchaseListQueryInfo: purchaseListQueryInfo) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let purchaseList):
                self.purchaseList = purchaseList
                DispatchQueue.main.async {
                    self.rootView.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
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
