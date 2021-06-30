//
//  PurchaseOrder.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct PurchaseOrder: Codable {
    // MARK: - LogInfo
    struct LogInfo: Codable {
        let createdDateString, status, reviewLevel, creater: String
        let createrName, note: String

        enum CodingKeys: String, CodingKey {
            case createdDateString = "created_at"
            case status
            case reviewLevel = "review_level"
            case creater = "created_by"
            case createrName = "created_by_name"
            case note = "remark"
        }
    }

    // MARK: - ProductInfo
    struct ProductInfo: Codable {
        let id, number, originalProductNumber, name: String
        let quantityPerBox, purchaseQuantity, purchaseBoxQuantity, stockUnitName: String
        let boxStockUnitName, purchaseCost, channelStockQuantity, fineStockQuantity: String
        let totalStockQuantity, monthSaleQuantity, suggestedQuantity, daysSalesOfInventory: String
        let cost, movingAverageCost, totalPrice, realPurchaseQuantity: String
        let realTotalPrice: String
        let imageInfos: [ImageInfo]

        enum CodingKeys: String, CodingKey {
            case id = "product_id"
            case number = "product_no"
            case originalProductNumber = "original_product_no"
            case name = "product_name"
            case quantityPerBox = "box_quantity"
            case purchaseQuantity = "purchase_quantity"
            case purchaseBoxQuantity = "purchase_box_quantity"
            case stockUnitName = "stock_unit_name"
            case boxStockUnitName = "box_stock_unit_name"
            case purchaseCost = "purchase_cost"
            case channelStockQuantity = "channel_stock_quantity"
            case fineStockQuantity = "fine_stock_quantity"
            case totalStockQuantity = "total_stock_quantity"
            case monthSaleQuantity = "month_sale_quantity"
            case suggestedQuantity = "proposed_quantity"
            case daysSalesOfInventory = "days_sales_of_inventory"
            case cost
            case movingAverageCost = "moving_average_cost"
            case totalPrice = "total_price"
            case realPurchaseQuantity = "real_purchase_quantity"
            case realTotalPrice = "real_total_price"
            case imageInfos = "image_info"
        }
    }
    let id, number: String
    let expectWarehouseType: Warehouse.WarehouseType
    let status: PurchaseStatus
    let expectWarehouseID, expectChannelWareroomID, expectStorageName, realAmount: String
    let realTax, realTotalAmount: String
    let recipientInfo: RecipientInfo
    let reviewLevel: String
    let lastReview: Bool
    let totalAmount, amount, tax, vendorName: String
    let vendorNumber, vendorID, expectStorageDate: String
    let productInfos: [ProductInfo]
    let logInfos: [LogInfo]

    enum CodingKeys: String, CodingKey {
        case id = "purchase_id"
        case number = "purchase_no"
        case status
        case expectWarehouseType = "expect_warehouse_type"
        case expectWarehouseID = "expect_warehouse_id"
        case expectChannelWareroomID = "expect_channel_wareroom_id"
        case expectStorageName = "expect_storage_name"
        case realAmount = "real_amount"
        case realTax = "real_tax"
        case realTotalAmount = "real_total_amount"
        case recipientInfo = "recipient_info"
        case reviewLevel = "review_level"
        case lastReview = "last_review"
        case totalAmount = "total_amount"
        case amount, tax
        case vendorName = "alias_name"
        case vendorNumber = "vendor_no"
        case vendorID = "vendor_id"
        case expectStorageDate = "expect_storage_date"
        case productInfos = "product_info"
        case logInfos = "log_info"
    }
}
