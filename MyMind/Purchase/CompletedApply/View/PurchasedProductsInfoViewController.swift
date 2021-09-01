//
//  PurchasedProductsInfoViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/23.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit
class PurchasedProductsInfoViewController: NiblessViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    var productInfos: [PurchaseOrder.ProductInfo] = []
    var totalCost: Float {
        get {
            productInfos.map {
                $0.totalPrice
            }.compactMap {
                $0 != nil ? $0! : 0
            }.reduce(0) { (sum, num) -> Float in
                return sum+num
            }
        }
    }
    var rootView: PurchasedProductsInfoRootView {
        return view as! PurchasedProductsInfoRootView
    }
    override func loadView() {
        view = PurchasedProductsInfoRootView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomBackNavigationItem()
        title = "採購SKU資訊"
        navigationItem.backButtonTitle = ""
        rootView.tableView.register(
            UINib(
                nibName: String(describing: PurchasedProductInfoTableViewCell.self),
                bundle: nil),
            forCellReuseIdentifier: String(describing: PurchasedProductInfoTableViewCell.self))
        rootView.tableView.separatorStyle = .none
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.config(with: productInfos.count, totalCost: totalCost)
    }
}
extension PurchasedProductsInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfos.count
    }
    @objc
    private func detailButtonDidTapped(_ sender: UIButton) {
        guard
            let point = sender.superview?.convert(sender.frame.origin, to: rootView.tableView),
            let indexPath = rootView.tableView.indexPathForRow(at: point)
        else {
            return
        }

        let info = productInfos[indexPath.item]
        let viewController = ProductMaterialSuggestionInfoTableViewController(viewModel: info.productSuggestionInfoViewModel)
        viewController.title = "SKU詳細資訊"
        show(viewController, sender: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(PurchasedProductInfoTableViewCell.self, for: indexPath) as? PurchasedProductInfoTableViewCell else {
            fatalError("Unabled to deque reusable cell")
        }

        let info = productInfos[indexPath.row]
        cell.configure(with: info)

        cell.detailButton.addTarget(self, action: #selector(detailButtonDidTapped(_:)), for: .touchUpInside)
        return cell
    }
}
extension PurchasedProductsInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
}
