//
//  PurchaseSuggestionInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct PurchaseSuggestionInfo: Codable {
    let id, number, originalProductNumber, name: String
    let quantityPerBox, channelStockQuantity, fineStockQuantity, totalStockQuantity: String
    let monthSaleQuantity, suggestedQuantity, daysSalesOfInventory, cost, untaxCoast: String
    let movingAverageCost, stockUnitName, boxStockUnitName: String
    let imageInfos: [ImageInfo]

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
        case suggestedQuantity = "proposed_quantity"
        case daysSalesOfInventory = "days_sales_of_inventory"
        case cost
        case untaxCoast = "untaxed_cost"
        case movingAverageCost = "moving_average_cost"
        case stockUnitName = "stock_unit_name"
        case boxStockUnitName = "box_stock_unit_name"
        case imageInfos = "image_info"
    }
}

struct PurchaseSuggestionInfoList: Codable {
    let items: [PurchaseSuggestionInfo]
    let vendorID: String
    let vendorNumber: String
    let vendorName: String

    enum CodingKeys: String, CodingKey {
        case items = "detail"
        case vendorID = "vendor_id"
        case vendorNumber = "vendor_no"
        case vendorName = "alias_name"
    }
}
