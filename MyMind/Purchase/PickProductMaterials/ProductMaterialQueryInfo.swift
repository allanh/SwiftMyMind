//
//  ProductMaterialQueryInfo.swift
//  MyMind
//
//  Created by Chen Yi-Wei on 2021/5/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ProductMaterialQueryInfo: Equatable {
    enum SortType: String, CustomStringConvertible, CaseIterable {
        case number = "PRODUCT_NO"
//        case name = "NAME"
//        case proposedPrice = "PROPOSED_PRICE"
//        case cost = "COST"
//        case vendorID = "VENDOR_ID"
//        case status = "STATUS"
//        case lastUpdate = "UPDATED_AT"
//        case creatDate = "CREATED_AT"
//        case brandName = "BRAND_NAME"
//        case isEnable = "IS_ENABLE"
        case originalNumber = "ORIGINAL_PRODUCT_NO"

        var description: String {
            switch self {
            case .number: return "SKU編號"
//            case .brandName: return "品牌名稱"
//            case .cost: return "最新採購成本"
//            case .creatDate: return "建立時間"
//            case .isEnable: return "是否啟用"
//            case .lastUpdate: return "更新時間"
//            case .name: return "物料名稱"
//            case .proposedPrice: return "建議售價"
//            case .status: return "品牌名稱"
//            case .vendorID: return "供貨商"
            case .originalNumber: return "原廠料號"
            }
        }
    }
    
    let vendorInfo: VendorInfo
    var brandNames: [AutoCompleteInfo] = []
    var materialNumbers: [AutoCompleteInfo] = []
    var materialSetNumbers: [AutoCompleteInfo] = []
    var originalMaterialNumbers: [AutoCompleteInfo] = []
    var materailNames: [String] = []
    var sortType: SortType = .number
    var sortOrder: SortOrder = .decending
    var pageNumber: Int = 1

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        let vendorID = vendorInfo.id
        let query = URLQueryItem(name: "vendor_id", value: vendorID)
        items.append(query)
        if brandNames.isEmpty == false {
            let names = brandNames.compactMap { $0.name }.joined(separator: ",")
            let query = URLQueryItem(name: "brand_name", value: names)
            items.append(query)
        }
        if materialNumbers.isEmpty == false {
            let numbers = materialNumbers.compactMap { $0.number }.joined(separator: ",")
            let query = URLQueryItem(name: "fuzzy_no", value: numbers)
            items.append(query)
        }
        if materialSetNumbers.isEmpty == false {
            let numbers = materialSetNumbers.compactMap { $0.number }.joined(separator: ",")
            let query = URLQueryItem(name: "product_set_no", value: numbers)
            items.append(query)
        } else {
            let query = URLQueryItem(name: "is_set", value: "false")
            items.append(query)
        }
        if materailNames.isEmpty == false {
            let names = materailNames.joined(separator: ",")
            let query = URLQueryItem(name: "name", value: names)
            items.append(query)
        }
        if originalMaterialNumbers.isEmpty == false {
            let numbers = originalMaterialNumbers.compactMap { $0.name }.joined(separator: ",")
            let query = URLQueryItem(name: "original_product_no", value: numbers)
            items.append(query)
        }
        let pageQuery = URLQueryItem(name: "current_page", value: String(pageNumber))
        items.append(pageQuery)
        let sortQuery = URLQueryItem(name: "order_by", value: sortType.rawValue)
        items.append(sortQuery)
        let orderQuery = URLQueryItem(name: "sort", value: sortOrder.rawValue)
        items.append(orderQuery)
        return items
    }
}
