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
    var maximumQuantity: Double {
        get {
            let maximunSaleQuantity: Int = reports.sorted {
                $0.saleQuantity > $1.saleQuantity
            }.first?.saleQuantity ?? 0
            let maximunCanceledQuantity: Int = reports.sorted {
                $0.canceledQuantity > $1.canceledQuantity
            }.first?.canceledQuantity ?? 0
            let maximunReturnQuantity: Int = reports.sorted {
                $0.returnQuantity > $1.returnQuantity
            }.first?.returnQuantity ?? 0
            return Double(max(maximunSaleQuantity, maximunCanceledQuantity, maximunReturnQuantity))
        }
    }
    var maximumAmount: Double {
        get {
            let maximunSaleAmount: Float = reports.sorted {
                $0.saleAmount > $1.saleAmount
            }.first?.saleAmount ?? 0
            let maximunCanceledAmount: Float = reports.sorted {
                $0.canceledAmount > $1.canceledAmount
            }.first?.canceledAmount ?? 0
            let maximunReturnAmount: Float = reports.sorted {
                $0.returnAmount > $1.returnAmount
            }.first?.returnAmount ?? 0
            return Double(max(maximunSaleAmount, maximunCanceledAmount, maximunReturnAmount))
        }
    }
}
struct SaleReports {
    let todayTransformedSaleReport: SaleReport?
    let todayShippedSaleReport: SaleReport?
    let yesterdayTransformedSaleReport: SaleReport?
    let yesterdayShippedSaleReport: SaleReport?
}
struct SKURankingReport: Codable {
    enum SKURankingReportSortOrder: String {
        case TOTAL_SALE_QUANTITY = "TOTAL_SALE_QUANTITY", TOTAL_SALE_AMOUNT = "TOTAL_SALE_AMOUNT"
    }
    private enum CodingKeys: String, CodingKey {
        case image = "image_url"
        case id = "product_no"
        case name = "product_name"
        case saleQuantity = "total_sale_quantity"
        case saleAmount = "total_sale_amount"
    }
    let image: String?
    let id: String
    let name: String
    let saleQuantity: Int
    let saleAmount: Float
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        image = try container.decode(String.self, forKey: .image)
//        id = try container.decode(String.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        saleQuantity = try container.decode(Int.self, forKey: .saleQuantity)
//        saleAmount = try container.decode(Float.self, forKey: .saleAmount)
//    }
}
struct SKURankingReportList: Codable {
    private enum CodingKeys: String, CodingKey {
        case reports = "detail"
    }
    let reports: [SKURankingReport]
    static let mock: Self = SKURankingReportList(reports: [SKURankingReport(image: "", id: "1", name: "【CONVERSE】1234567890 All Star CHUCK 70 男女 高筒 休閒鞋", saleQuantity: 99999999, saleAmount: 66666666.0), SKURankingReport(image: "", id: "2", name: "【SASAKI 棉質吸濕排汗功能運動休閒長衫-女-深葡", saleQuantity: 9999999, saleAmount: 6666666.0), SKURankingReport(image: "", id: "3", name: "SASAKI 棉質吸濕排汗功能運動休閒長衫-女-深葡", saleQuantity: 999999, saleAmount: 666666.0), SKURankingReport(image: "", id: "4", name: "SK-II 亮采化妝水160ml", saleQuantity: 99999, saleAmount: 66666.0), SKURankingReport(image: "", id: "5", name: "【Philips 飛利浦】耳掛式耳機SHS4700", saleQuantity: 9999, saleAmount: 6666.0)])
}
//struct SKURankingReports {
//    let rankingReportList: SKURankingReportList
//    let setRankingReportList: SKURankingReportList
//}

struct SaleRankingReport: Codable {
    enum SaleRankingReportDevider: CustomStringConvertible {
        case store, vendor
        var description: String {
            get {
                switch self {
                case .store: return "通路"
                case .vendor: return "供應商"
                }
            }
        }
    }
    private enum CodingKeys: String, CodingKey {
        case store = "channel_store_name"
        case vendor = "vendor_name"
        case saleAmount = "total_sale_amount"
        case saleGrossProfit = "sale_gross_profit"
    }
    let name: String
    let saleAmount: Float
    let saleGrossProfit: Float
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let string = try? container.decode(String.self, forKey: .store) {
            name = string
        } else {
            name = try container.decode(String.self, forKey: .vendor)
        }
        saleAmount = try container.decode(Float.self, forKey: .saleAmount)
        saleGrossProfit = try container.decode(Float.self, forKey: .saleGrossProfit)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .store)
        try container.encode(saleAmount, forKey: .saleAmount)
        try container.encode(saleGrossProfit, forKey: .saleGrossProfit)
    }
}

struct SaleRankingReportList: Codable {
    private enum CodingKeys: String, CodingKey {
        case reports = "detail"
    }
    let reports: [SaleRankingReport]
}
/*
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
*/
