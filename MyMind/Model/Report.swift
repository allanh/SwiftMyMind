//
//  Report.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
struct SaleReport: Codable {
    enum SaleReportType {
        case byType
        case byDate
    }
    enum ReportType: String, Codable {
        case TRANSFORMED, SHIPPED
        var displayName: String {
            get {
                switch self {
                case .TRANSFORMED: return "轉單"
                case .SHIPPED: return "寄倉"
                }
            }
        }
    }
    private enum CodingKeys: String, CodingKey {
        case type
        case date = "channel_receipt_date"
        case saleQuantity = "total_sale_quantity"
        case returnQuantity = "total_return_quantity"
        case canceledQuantity = "total_canceled_quantity"
        case saleAmount = "total_sale_amount"
        case returnAmount = "total_return_amount"
        case canceledAmount = "total_canceled_amount"
    }
    let type: ReportType?
    let date: String?
    let saleQuantity: Int
    let returnQuantity: Int
    let canceledQuantity: Int
    let saleAmount: Float
    let returnAmount: Float
    let canceledAmount: Float
}
struct SaleReportList: Codable {
    private enum CodingKeys: String, CodingKey {
        case reports = "detail"
    }
    let reports: [SaleReport]
}
struct SaleReports {
    let todayTransformedSaleReport: SaleReport?
    let todayShippedSaleReport: SaleReport?
    let dateSaleReportList: SaleReportList
}
enum SKURankingReportSortOrder: String {
    case TOTAL_SALE_QUANTITY = "TOTAL_SALE_QUANTITY", TOTAL_SALE_AMOUNT = "TOTAL_SALE_AMOUNT"
}
struct SKURankingReport: Codable {
    private enum CodingKeys: String, CodingKey {
        case image = "image_url"
        case id = "product_no"
        case name = "product_name"
        case saleQuantity = "total_sale_quantity"
        case saleAmount = "total_sale_amount"
    }
    let image: String
    let id: String
    let name: String
    let saleQuantity: Int
    let saleAmount: Float
}
struct SKURankingReportList: Codable {
    private enum CodingKeys: String, CodingKey {
        case reports = "detail"
    }
    let reports: [SKURankingReport]
}
struct SKURankingReports {
    let rankingReportList: SKURankingReportList
    let setRankingReportList: SKURankingReportList
}
struct StoreRankingReport: Codable {
    private enum CodingKeys: String, CodingKey {
        case name = "channel_store_name"
        case saleAmount = "total_sale_amount"
        case saleGrossProfit = "sale_gross_profit"
    }
    let name: String
    let saleAmount: Float
    let saleGrossProfit: Float
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//    }
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//    }
}
struct StoreRankingReportList: Codable {
    private enum CodingKeys: String, CodingKey {
        case reports = "detail"
    }
    let reports: [StoreRankingReport]
}

struct ChannelRankingReport: Codable {
    private enum CodingKeys: String, CodingKey {
        case name = "vendor_name"
        case saleAmount = "total_sale_amount"
        case saleGrossProfit = "sale_gross_profit"
    }
    let name: String
    let saleAmount: Float
    let saleGrossProfit: Float
}
struct ChannelRankingReportList: Codable {
    private enum CodingKeys: String, CodingKey {
        case reports = "detail"
    }
    let reports: [ChannelRankingReport]
}
struct SaleRankingReports {
    let storeRankingReportList: StoreRankingReportList
    let channelRankingReportList: ChannelRankingReportList
}
