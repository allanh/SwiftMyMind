//
//  ProductMaterial.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ImageInfo: Codable, Equatable {
    let id: String
    let url: String
}
// MARK: Product Material
struct ProductMaterial: Codable, Equatable {
    enum Action: String, Codable {
        case edit = "EDIT"
        case copy = "COPY"
        case delete = "DELETE"
    }

    enum Attribute: String, Codable {
        case general = "GENERAL"
        case spot = "SPOT"
        case giveAway = "GIVEAWAY"
    }

    enum SpecType: String, Codable {
        case none = "NONE"
        case single = "SINGLE"
        case double = "DOUBLE"
    }

//    enum Status: String, Codable {
//        case discontinued = "DISCONTINUED"
//    }
    let id, number: String
    let isSet: Bool
    let name, grossProfitMargin: String
    let proposedPrice: String
    let latestPurchaseCost: String
    let untaxedMovingAverageCost: Double
    let unitName, safetyStock, dynamicSafetyStockQuantity, marketPrice: String
    let vendorID, vendorNo, aliasName, brandName: String
    let originalProductNo: String
    let imageInfoList: [ImageInfo]
    let createdDateString, updatedDateString: String
    let status: String
    let allowedActions: [Action]
    let specType: SpecType
    let quantity, specName1, specName2: String
    let subProductInfo: [ProductMaterialBrief]
    let attribute: Attribute
    let isEnable: Bool

    private enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case number = "product_no"
        case isSet = "is_set"
        case name
        case proposedPrice = "proposed_price"
        case grossProfitMargin = "gross_profit_margin"
        case latestPurchaseCost = "cost"
        case untaxedMovingAverageCost = "untaxed_moving_average_cost"
        case unitName = "unit_name"
        case safetyStock = "safety_stock"
        case dynamicSafetyStockQuantity = "dynamic_safety_stock_quantity"
        case marketPrice = "market_price"
        case vendorID = "vendor_id"
        case vendorNo = "vendor_no"
        case aliasName = "alias_name"
        case brandName = "brand_name"
        case originalProductNo = "original_product_no"
        case imageInfoList = "image_info"
        case createdDateString = "created_at"
        case updatedDateString = "updated_at"
        case status, quantity
        case allowedActions = "button"
        case specType = "spec_type"
        case specName1 = "spec_name_1"
        case specName2 = "spec_name_2"
        case subProductInfo = "sub_product_info"
        case attribute
        case isEnable = "is_enable"
    }
}

struct ProductMaterialBrief: Codable, Equatable {
    let id: String
    let number: String
    let name: String
    let quantity: String

    private enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case number = "product_no"
        case name, quantity
    }
}
// MARK: Product Material List
struct ProductMaterialList: MultiplePageList {
    let totalAmountOfItems: Int
    let totalAmountOfPages: Int
    let itemsPerPage: Int
    let currentPageNumber: Int
    let materials: [ProductMaterial]

    private enum CodingKeys: String, CodingKey {
        case materials = "detail"
        case statusAmount = "status_amount"
        case totalAmountOfItems = "total"
        case totalAmountOfPages = "total_page"
        case currentPageNumber = "current_page"
        case itemsPerPage = "limit"
    }
}
extension ProductMaterialList: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        materials = try container.decode([ProductMaterial].self, forKey: .materials)
        var string = try container.decode(String.self, forKey: .totalAmountOfItems)
        totalAmountOfItems = Int(string) ?? 0
        string = try container.decode(String.self, forKey: .totalAmountOfPages)
        totalAmountOfPages = Int(string) ?? 0
        string = try container.decode(String.self, forKey: .currentPageNumber)
        currentPageNumber = Int(string) ?? 0
        string = try container.decode(String.self, forKey: .itemsPerPage)
        itemsPerPage = Int(string) ?? 0
    }
}
