//
//  ProductMaterialSuggestionInfoTableViewController.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/4.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import UIKit

class ProductMaterialSuggestionInfoTableViewController: UITableViewController {

    typealias PurchaseSuggestionInfoItem = (title: String, content: String)

    var purchaseSuggestionInfo: PurchaseSuggestionInfo?

    lazy var itemList: [PurchaseSuggestionInfoItem] = {
        if let info = self.purchaseSuggestionInfo {
            return [
                ("SKU編號", info.number),
                ("原廠料號", info.originalProductNumber),
                ("SKU名稱", info.name),
                ("通路倉庫存量", info.channelStockQuantity),
                ("良品倉庫存量", info.fineStockQuantity),
                ("月平鈞銷售量\n(庫存單位)", info.monthSaleQuantity),
                ("迴轉天數", info.daysSalesOfInventory),
                ("建議採購量", info.suggestedQuantity),
                ("箱入數", "\(info.number)\(info.stockUnitName)/\(info.boxStockUnitName)"),
                ("最新採購成本", info.cost),
                ("移動平均成本", info.movingAverageCost),
            ]
        } else {
            return []
        }
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: String(describing: ProductMaterialSuggestionInfoTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductMaterialSuggestionInfoTableViewCell.self))
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeReusableCell(ProductMaterialSuggestionInfoTableViewCell.self, for: indexPath) as? ProductMaterialSuggestionInfoTableViewCell else {
            return UITableViewCell()
        }
        let item = itemList[indexPath.row]
        cell.config(with: item.title, content: item.content)

        let isLastRow = indexPath.row == itemList.count - 1
        cell.bottomBorderView.isHidden = !isLastRow

        return cell
    }
}
