//
//  ProductMaterialDetail.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/6/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ProductMaterialDetail: Codable {
    // MARK: - LatestCost
    struct LatestCost: Codable {
        let updatedDate, cost, untaxedCost, inputTax: String

        enum CodingKeys: String, CodingKey {
            case updatedDate = "updated_at"
            case cost
            case untaxedCost = "untaxed_cost"
            case inputTax = "input_tax"
        }
    }

    enum ShortShelfLifeType: String, Codable {
        case nothing = "NOTHING"
        case percent = "PERCENT"
        case fixed = "FIXED"
    }

    enum DateComponent: String, Codable {
        case day = "DAY"
        case month = "MONTH"
        case year = "YEAR"
    }

    let productID: String
    let isSet: Bool
    let partnerID, productNo, name, vendorID: String
    let aliasName, brandName, marketPrice, proposedPrice: String
    let cost, untaxedCost: String
    let latestCostList: [LatestCost]
    let costUpdatedAt, movingAverageCost, untaxedMovingAverageCost, movingAverageCostUpdatedAt: String
    let inputTax, outputTax, dynamicSafetyStockQuantity, boxLength: String
    let boxWidth, boxHeight, boxWeight, temperatureLayer: String
    let imageInfo: [ImageInfo]
    let createdBy, updatedBy, createdAt, updatedAt: String
    let precautions: String
    let isDiscontinued: Bool
    let discontinuedDate, discontinuedRemark: String
    let isModifiable: Bool
    let attribute: String
    let isEnable: Bool
    let productPurchaseCategoryID, modelName, specType, specName1: String
    let specName2, originalPlace, originalProductNo, brandCompanyName: String
    let stockUnitID: Int
    let stockUnitName, safetyStock: String
    let boxStockUnitID: Int
    let boxStockUnitName, boxQuantity: String
    let palletQuantity: Int?
    let shelfLife, shelfLifeType, ean, boxEan: String
    let material, length, width, height: String
    let weight, minimumPurchase: String
    let isPermanent: Bool
    let shortShelfLifeType: ShortShelfLifeType
    let shortShelfLifeRatio: Int
    let shortShelfLifeUnit: DateComponent?
    let shortShelfLifeValue: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case isSet = "is_set"
        case partnerID = "partner_id"
        case productNo = "product_no"
        case name
        case vendorID = "vendor_id"
        case aliasName = "alias_name"
        case brandName = "brand_name"
        case marketPrice = "market_price"
        case proposedPrice = "proposed_price"
        case cost
        case untaxedCost = "untaxed_cost"
        case latestCostList = "latest_cost"
        case costUpdatedAt = "cost_updated_at"
        case movingAverageCost = "moving_average_cost"
        case untaxedMovingAverageCost = "untaxed_moving_average_cost"
        case movingAverageCostUpdatedAt = "moving_average_cost_updated_at"
        case inputTax = "input_tax"
        case outputTax = "output_tax"
        case dynamicSafetyStockQuantity = "dynamic_safety_stock_quantity"
        case boxLength = "box_length"
        case boxWidth = "box_width"
        case boxHeight = "box_height"
        case boxWeight = "box_weight"
        case temperatureLayer = "temperature_layer"
        case imageInfo = "image_info"
        case createdBy = "created_by"
        case updatedBy = "updated_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case precautions
        case isDiscontinued = "is_discontinued"
        case discontinuedDate = "discontinued_date"
        case discontinuedRemark = "discontinued_remark"
        case isModifiable = "is_modifiable"
        case attribute
        case isEnable = "is_enable"
        case productPurchaseCategoryID = "product_purchase_category_id"
        case modelName = "model_name"
        case specType = "spec_type"
        case specName1 = "spec_name_1"
        case specName2 = "spec_name_2"
        case originalPlace = "original_place"
        case originalProductNo = "original_product_no"
        case brandCompanyName = "brand_company_name"
        case stockUnitID = "stock_unit_id"
        case stockUnitName = "stock_unit_name"
        case safetyStock = "safety_stock"
        case boxStockUnitID = "box_stock_unit_id"
        case boxStockUnitName = "box_stock_unit_name"
        case boxQuantity = "box_quantity"
        case palletQuantity = "pallet_quantity"
        case shelfLife = "shelf_life"
        case shelfLifeType = "shelf_life_type"
        case ean
        case boxEan = "box_ean"
        case material, length, width, height, weight
        case minimumPurchase = "minimum_purchase"
        case isPermanent = "is_permanent"
        case shortShelfLifeType = "short_shelf_life_type"
        case shortShelfLifeRatio = "short_shelf_life_ratio"
        case shortShelfLifeUnit = "short_shelf_life_unit"
        case shortShelfLifeValue = "short_shelf_life_value"
    }
}
