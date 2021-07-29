//
//  ApplyPurchaseParameterInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/9.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ApplyPurchaseParameterInfo: Codable {
    // MARK: - ProductInfo
    struct ProductInfo: Codable {
        let productID, purchaseQuantity, proposedQuantity, channelStockQuantity: String
        let fineStockQuantity, purchaseCost, totalPrice: String

        enum CodingKeys: String, CodingKey {
            case productID = "product_id"
            case purchaseQuantity = "purchase_quantity"
            case proposedQuantity = "proposed_quantity"
            case channelStockQuantity = "channel_stock_quantity"
            case fineStockQuantity = "fine_stock_quantity"
            case purchaseCost = "purchase_cost"
            case totalPrice = "total_price"
        }
    }

    let partnerID, vendorID, expectStorageDate, reviewBy: String
    let remark, expectWarehouseID: String
    let expectWarehouseType: Warehouse.WarehouseType
    let warehouseIndex: Int
    let productInfo: [ProductInfo]

    enum CodingKeys: String, CodingKey {
        case partnerID = "partner_id"
        case vendorID = "vendor_id"
        case expectStorageDate = "expect_storage_date"
        case reviewBy = "review_by"
        case remark
        case warehouseIndex = "warehouse_index"
        case expectWarehouseType = "expect_warehouse_type"
        case expectWarehouseID = "expect_warehouse_id"
        case productInfo = "product_info"
    }
}
