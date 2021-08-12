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

    let viewModel: ProductSuggestionInfoViewModel

    lazy var itemList: [PurchaseSuggestionInfoItem] = [
        ("SKU編號", viewModel.number),
        ("原廠料號", viewModel.originalProductNumber),
        ("SKU名稱", viewModel.name),
        ("通路倉庫存量", viewModel.channelStockQuantity),
        ("良品倉庫存量", viewModel.fineStockQuantity),
        ("總庫存量", viewModel.fineStockQuantity),
        ("月平鈞銷售量\n(庫存單位)", viewModel.monthSaleQuantity),
        ("迴轉天數", viewModel.daysSalesOfInventory),
        ("建議採購量", viewModel.suggestedQuantity),
        ("箱入數", "\(viewModel.quantityPerBox)\(viewModel.stockUnitName)/\(viewModel.boxStockUnitName)"),
        ("最新採購成本(未稅)", viewModel.cost),
        ("移動平均成本(未稅)", viewModel.movingAverageCost),
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        title = "建議採購資訊"
        tableView.register(UINib(nibName: String(describing: ProductMaterialSuggestionInfoTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductMaterialSuggestionInfoTableViewCell.self))
        tableView.rowHeight = 44
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
    }

    init(viewModel: ProductSuggestionInfoViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        var content = item.content
        switch indexPath.row {
        case 3, 4, 5, 6, 8:
            let formatter: NumberFormatter = NumberFormatter {
                $0.numberStyle = .currency
                $0.currencySymbol = ""
                $0.maximumFractionDigits = 0
            }
            let value = Int(content)
            content = formatter.string(from: NSNumber(value: value ?? 0)) ?? ""
        case 10, 11:
            let formatter: NumberFormatter = NumberFormatter {
                $0.numberStyle = .currency
                $0.currencySymbol = ""
            }
            let value = Float(content)
            content = formatter.string(from: NSNumber(value: value ?? 0)) ?? ""
        default:
            break
        }
        cell.config(with: item.title, content: content)

        let isLastRow = indexPath.row == itemList.count - 1
        cell.bottomBorderView.isHidden = !isLastRow

        return cell
    }
}
