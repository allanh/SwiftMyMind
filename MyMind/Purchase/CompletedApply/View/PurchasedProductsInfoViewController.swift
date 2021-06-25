//
//  PurchasedProductsInfoViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/23.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class PurchasedProductsInfoViewController: UITableViewController {

    var productInfos: [PurchaseOrder.ProductInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "採購SKU資訊"

        tableView.register(
            UINib(
                nibName: String(describing: PurchasedProductInfoTableViewCell.self),
                bundle: nil),
            forCellReuseIdentifier: String(describing: PurchasedProductInfoTableViewCell.self))
        tableView.separatorStyle = .none
    }

    @objc
    private func detailButtonDidTapped(_ sender: UIButton) {
        guard
            let point = sender.superview?.convert(sender.frame.origin, to: tableView),
            let indexPath = tableView.indexPathForRow(at: point)
        else {
            return
        }

        let info = productInfos[indexPath.item]
        let viewController = ProductMaterialSuggestionInfoTableViewController(viewModel: info.productSuggestionInfoViewModel)
        viewController.title = "SKU詳細資訊"
        show(viewController, sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(PurchasedProductInfoTableViewCell.self, for: indexPath) as? PurchasedProductInfoTableViewCell else {
            fatalError("Unabled to deque reusable cell")
        }

        let info = productInfos[indexPath.row]
        cell.configure(with: info)

        cell.detailButton.addTarget(self, action: #selector(detailButtonDidTapped(_:)), for: .touchUpInside)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
}
