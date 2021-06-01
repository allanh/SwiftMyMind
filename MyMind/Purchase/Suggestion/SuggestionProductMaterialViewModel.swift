//
//  SuggestionProductMaterialViewModel.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

struct SuggestionProductMaterialViewModel {
    let imageURL: URL?
    let number: String
    let originalProductNumber: String
    let name: String
    let purchaseSuggestionQuantity: String
    let stockUnitName: String
    let quantityPerBox: Int
    let purchaseSuggestionInfo: PurchaseSuggestionInfo
    let purchaseCostPerItem: BehaviorRelay<Float>
    let purchaseQuantity: BehaviorRelay<Int> = .init(value: 0)
    let puchaseCost: BehaviorRelay<Float> = .init(value: 0)
}

struct PurchaseSuggestionInfo: Codable {
    let id, number, originalProductNumber, name: String
    let quantityPerBox, channelStockQuantity, fineStockQuantity, totalStockQuantity: String
    let monthSaleQuantity, proposedQuantity, daysSalesOfInventory, cost: String
    let movingAverageCost, stockUnitName, boxStockUnitName: String

    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case number = "product_no"
        case originalProductNumber = "original_product_no"
        case name = "product_name"
        case quantityPerBox = "box_quantity"
        case channelStockQuantity = "channel_stock_quantity"
        case fineStockQuantity = "fine_stock_quantity"
        case totalStockQuantity = "total_stock_quantity"
        case monthSaleQuantity = "month_sale_quantity"
        case proposedQuantity = "proposed_quantity"
        case daysSalesOfInventory = "days_sales_of_inventory"
        case cost
        case movingAverageCost = "moving_average_cost"
        case stockUnitName = "stock_unit_name"
        case boxStockUnitName = "box_stock_unit_name"
    }
}

struct PurchaseSuggestionInfoList: Codable {
    let items: [PurchaseSuggestionInfo]

    enum CodingKeys: String, CodingKey {
        case items = "detail"
    }
}
