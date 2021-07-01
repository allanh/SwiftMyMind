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
        let createdDateString, status, creater: String
        let reviewLevel: Int
        let createrName: String
        let note: String?

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
        let id: Int
        let number, name: String
        let originalProductNumber: String?
        let quantityPerBox, purchaseQuantity: Int
        let purchaseBoxQuantity: Float
        let stockUnitName, boxStockUnitName: String
        let purchaseCost: Float
        let channelStockQuantity, fineStockQuantity, monthSaleQuantity, suggestedQuantity : Int
        let totalStockQuantity, daysSalesOfInventory: Int?
        let cost, movingAverageCost, totalPrice: Float?
        let realPurchaseQuantity, realTotalPrice: Float?
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
//        init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            id = try container.decode(Int.self, forKey: .id)
//            number = try container.decode(String.self, forKey: .number)
//            name = try container.decode(String.self, forKey: .name)
//            originalProductNumber = try? container.decode(String.self, forKey: .originalProductNumber)
//            quantityPerBox = try container.decode(Int.self, forKey: .quantityPerBox)
//            purchaseQuantity = try container.decode(Int.self, forKey: .purchaseQuantity)
//            purchaseBoxQuantity = try container.decode(Float.self, forKey: .purchaseBoxQuantity)
//            stockUnitName = try container.decode(String.self, forKey: .stockUnitName)
//            boxStockUnitName = try container.decode(String.self, forKey: .boxStockUnitName)
//            purchaseCost = try container.decode(Float.self, forKey: .purchaseCost)
//            channelStockQuantity = try container.decode(Int.self, forKey: .channelStockQuantity)
//            fineStockQuantity = try container.decode(Int.self, forKey: .fineStockQuantity)
//            totalStockQuantity = try? container.decode(Int.self, forKey: .totalStockQuantity)
//            monthSaleQuantity = try container.decode(Int.self, forKey: .monthSaleQuantity)
//            suggestedQuantity = try container.decode(Int.self, forKey: .suggestedQuantity)
//            daysSalesOfInventory = try? container.decode(Int.self, forKey: .daysSalesOfInventory)
//            cost = try? container.decode(Float.self, forKey: .cost)
//            movingAverageCost = try? container.decode(Float.self, forKey: .movingAverageCost)
//            totalPrice = try? container.decode(Float.self, forKey: .totalPrice)
//            realPurchaseQuantity = try? container.decode(Float.self, forKey: .realPurchaseQuantity)
//            realTotalPrice = try? container.decode(Float.self, forKey: .realTotalPrice)
//            imageInfos = try container.decode([ImageInfo].self, forKey: .imageInfos)
//       }
    }
    let id: Int
    let number: String
    let status: PurchaseStatus
    let expectWarehouseType: Warehouse.WarehouseType
    let expectWarehouseID: Int
    let expectChannelWareroomID: String?
    let expectStorageName: String
    let realAmount, realTax, realTotalAmount: String?
    let recipientInfo: RecipientInfo
    let reviewLevel: Int
    let lastReview: Bool
    let totalAmount: Int
    let amount, tax: Float
    let vendorName: String
    let vendorNumber, expectStorageDate: String
    let vendorID: Int
    let productInfos: [ProductInfo]
    let logInfos: [LogInfo]

    enum CodingKeys: String, CodingKey {
        case id = "purchase_id"
        case number = "purchase_no"
        case status
        case expectWarehouseType = "expect_warehouse_type"
        case expectWarehouseID = "expect_warehouse_id"
        case expectChannelWareroomID = "expect_channel_wareroom_id"
        case expectStorageName = "expect_warehouse_name"
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
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        number = try container.decode(String.self, forKey: .number)
        status = try container.decode(PurchaseStatus.self, forKey: .status)
        expectWarehouseType =  try container.decode(Warehouse.WarehouseType.self, forKey: .expectWarehouseType)
        expectWarehouseID = try container.decode(Int.self, forKey: .expectWarehouseID)
        expectChannelWareroomID = try? container.decode(String.self, forKey: .expectChannelWareroomID)
        expectStorageName = try container.decode(String.self, forKey: .expectStorageName)
        realAmount = try? container.decode(String.self, forKey: .realAmount)
        realTax = try? container.decode(String.self, forKey: .realTax)
        realTotalAmount = try? container.decode(String.self, forKey: .realTotalAmount)
        recipientInfo = try container.decode(RecipientInfo.self, forKey: .recipientInfo)
        reviewLevel = try container.decode(Int.self, forKey: .reviewLevel)
        lastReview = try container.decode(Bool.self, forKey: .lastReview)
        totalAmount = try container.decode(Int.self, forKey: .totalAmount)
        amount = try container.decode(Float.self, forKey: .amount)
        tax = try container.decode(Float.self, forKey: .tax)
        vendorName = try container.decode(String.self, forKey: .vendorName)
        vendorNumber = try container.decode(String.self, forKey: .vendorNumber)
        expectStorageDate = try container.decode(String.self, forKey: .expectStorageDate)
        vendorID = try container.decode(Int.self, forKey: .vendorID)
        productInfos = try container.decode([ProductInfo].self, forKey: .productInfos)
        logInfos = try container.decode([LogInfo].self, forKey: .logInfos)
    }
}
