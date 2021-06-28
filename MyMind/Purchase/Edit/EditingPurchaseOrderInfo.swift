//
//  EditingPurchaseOrderInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/28.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct EditingPurchaseOrderParameterInfo: Codable {
    // MARK: - ProductInfo
    struct ProductInfo: Codable {
        let productID, purchaseQuantity, purchaseCost, totalPrice: String

        enum CodingKeys: String, CodingKey {
            case productID = "product_id"
            case purchaseQuantity = "purchase_quantity"
            case purchaseCost = "purchase_cost"
            case totalPrice = "total_price"
        }
    }

    let expectStorageDate, reviewBy, remark: String
    let expectWarehouseID: String
    let expectWarehouseType: Warehouse.WarehouseType
    let productInfo: [ProductInfo]

    enum CodingKeys: String, CodingKey {
        case expectStorageDate = "expect_storage_date"
        case reviewBy = "review_by"
        case remark
        case expectWarehouseType = "expect_warehouse_type"
        case expectWarehouseID = "expect_warehouse_id"
        case productInfo = "product_info"
    }
}


