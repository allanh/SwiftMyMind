//
//  ProductMaterialQueryInfo.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ProductMaterialQueryInfo {
    enum SortType: String, CustomStringConvertible, CaseIterable {
        case number = "PRODUCT_NO"
        case name = "NAME"
        case proposedPrice = "PROPOSED_PRICE"
        case cost = "COST"
        case vendorID = "VENDOR_ID"
        case status = "STATUS"
        case lastUpdate = "UPDATED_AT"
        case creatDate = "CREATED_AT"
        case brandName = "BRAND_NAME"
        case isEnable = "IS_ENABLE"

        var description: String {
            switch self {
            case .number: return "物料編號"
            case .brandName: return "品牌名稱"
            case .cost: return "最新採購成本"
            case .creatDate: return "建立時間"
            case .isEnable: return "是否啟用"
            case .lastUpdate: return "更新時間"
            case .name: return "物料名稱"
            case .proposedPrice: return "建議售價"
            case .status: return "品牌名稱"
            case .vendorID: return "供貨商"
            }
        }
    }
    var vendorIDs: [String]
    var brandNames: [String]
    var materialNumbers: [String]
    var originalMaterialNumbers: [String]
    var materailNames: [String]
    var sortType: SortType = .number
    var pageNumber: Int = 1

    static func defaultQuery() -> Self {
        return ProductMaterialQueryInfo(vendorIDs: [], brandNames: [], materialNumbers: [], originalMaterialNumbers: [], materailNames: [])
    }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        if vendorIDs.isEmpty == false {
            let ids = vendorIDs.joined(separator: ",")
            let query = URLQueryItem(name: "vendor_id", value: ids)
            items.append(query)
        }
        if brandNames.isEmpty == false {
            let names = brandNames.joined(separator: ",")
            let query = URLQueryItem(name: "brand_name", value: names)
            items.append(query)
        }
        if materialNumbers.isEmpty == false {
            let numbers = materialNumbers.joined(separator: ",")
            let query = URLQueryItem(name: "fuzzy_no", value: numbers)
            items.append(query)
        }
        if materailNames.isEmpty == false {
            let names = materailNames.joined(separator: ",")
            let query = URLQueryItem(name: "name", value: names)
            items.append(query)
        }
        if originalMaterialNumbers.isEmpty == false {
            let numbers = originalMaterialNumbers.joined(separator: ",")
            let query = URLQueryItem(name: "original_product_no", value: numbers)
            items.append(query)
        }
        let sortQuery = URLQueryItem(name: "order_by", value: sortType.rawValue)
        items.append(sortQuery)
        return items
    }
}
