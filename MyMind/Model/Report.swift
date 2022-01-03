//
//  Report.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/11.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
// MARK: -- SaleReport --
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
// MARK: -- SaleReportList --
struct SaleReportList: Codable {
    private enum CodingKeys: String, CodingKey {
        case reports = "detail"
    }
    let reports: [SaleReport]
    var maximumSaleQuantity: Int {
        return reports.sorted {
            $0.saleQuantity > $1.saleQuantity
        }.first?.saleQuantity ?? 0
    }
    var minimumSaleQuantity: Int {
        return reports.sorted {
            $0.saleQuantity < $1.saleQuantity
        }.first?.saleQuantity ?? 0
    }
    var totalSaleQuantity: Double {
        get {
            let result = reports.map({$0.saleQuantity}).reduce(0, +)
            return Double(result)
        }
    }
    var maximumCanceledQuantity: Int {
        return reports.sorted {
            $0.canceledQuantity > $1.canceledQuantity
        }.first?.canceledQuantity ?? 0
    }
    var minimumCanceledQuantity: Int {
        return reports.sorted {
            $0.canceledQuantity < $1.canceledQuantity
        }.first?.canceledQuantity ?? 0
    }
    var totalCanceledQuantity: Double {
        get {
            let result = reports.map({$0.canceledQuantity}).reduce(0, +)
            return Double(result)
        }
    }
    var maximumReturnQuantity: Int {
        return reports.sorted {
            $0.returnQuantity > $1.returnQuantity
        }.first?.returnQuantity ?? 0
    }
    var minimumReturnQuantity: Int {
        return reports.sorted {
            $0.returnQuantity < $1.returnQuantity
        }.first?.returnQuantity ?? 0
    }
    var totalReturnQuantity: Double {
        get {
            let result = reports.map({$0.returnQuantity}).reduce(0, +)
            return Double(result)
        }
    }
    var maximumQuantity: Double {
        get {
            return Double(max(maximumSaleQuantity, maximumCanceledQuantity, maximumReturnQuantity))
        }
    }
    
    var maximumSaleAmount: Float {
        return reports.sorted {
            $0.saleAmount > $1.saleAmount
        }.first?.saleAmount ?? 0
    }
    var minimumSaleAmount: Float {
        return reports.sorted {
            $0.saleAmount < $1.saleAmount
        }.first?.saleAmount ?? 0
    }
    var totalSaleAmount: Double {
        get {
            let result = reports.map({$0.saleAmount}).reduce(0, +)
            return Double(result)
        }
    }
    var maximumCanceledAmount: Float {
        return reports.sorted {
            $0.canceledAmount > $1.canceledAmount
        }.first?.canceledAmount ?? 0
    }
    var minimumCanceledAmount: Float {
        return reports.sorted {
            $0.canceledAmount < $1.canceledAmount
        }.first?.canceledAmount ?? 0
    }
    var totalCanceledAmount: Double {
        get {
            let result = reports.map({$0.canceledAmount}).reduce(0, +)
            return Double(result)
        }
    }
    var maximumReturnAmount: Float {
        return reports.sorted {
            $0.returnAmount > $1.returnAmount
        }.first?.returnAmount ?? 0
    }
    var minimumReturnAmount: Float {
        return reports.sorted {
            $0.returnAmount < $1.returnAmount
        }.first?.returnAmount ?? 0
    }
    var totalReturnAmount: Double {
        get {
            let result = reports.map({$0.returnAmount}).reduce(0, +)
            return Double(result)
        }
    }
    var maximumAmount: Double {
        get {
            return Double(max(maximumSaleAmount, maximumCanceledAmount, maximumReturnAmount))
        }
    }
    
    // 起迄時間
    var startDate: Date?
    var endDate: Date?
    
    // 取得數量
    func totalQuantity(pointsType: SaleReportList.SaleReportPointsType) -> Double {
        switch pointsType {
        case .sale: return totalSaleQuantity
        case .cancel: return totalCanceledQuantity
        case .returned: return totalReturnQuantity
        }
    }
    
    // 取得總額
    func totalAmount(pointsType: SaleReportList.SaleReportPointsType) -> Double {
        switch pointsType {
        case .sale: return totalSaleAmount
        case .cancel: return totalCanceledAmount
        case .returned: return totalReturnAmount
        }
    }
}
// MARK: -- SaleReports --
struct SaleReports {
    let dateString: String?
    let todayTransformedSaleReport: SaleReport?
    let todayShippedSaleReport: SaleReport?
    let yesterdayTransformedSaleReport: SaleReport?
    let yesterdayShippedSaleReport: SaleReport?
    static let empty: Self = SaleReports(dateString: nil, todayTransformedSaleReport: nil, todayShippedSaleReport: nil, yesterdayTransformedSaleReport: nil, yesterdayShippedSaleReport: nil)
}

// MARK: -- SKURankingReport --
struct SKURankingReport: Codable {
    enum SKURankingReportSortOrder: String, CaseIterable {
        case TOTAL_SALE_QUANTITY = "TOTAL_SALE_QUANTITY", TOTAL_SALE_AMOUNT = "TOTAL_SALE_AMOUNT"
        var index: Int {
            get {
                switch self {
                case .TOTAL_SALE_QUANTITY: return 0
                case .TOTAL_SALE_AMOUNT: return 1
                }
            }
        }
        var description: String {
            get {
                switch self {
                case .TOTAL_SALE_QUANTITY:
                    return "銷售數量"
                case .TOTAL_SALE_AMOUNT:
                    return "銷售總額"
                }
            }
        }
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
// MARK: -- SKURankingReportList --
struct SKURankingReportList: Codable {
    enum sevenDaysType: Int, CaseIterable {
        case commodity = 0
        case combined_commodity
        
        var description: String {
            get {
                switch self {
                case .commodity:
                    return "近7日SKU排行"
                case .combined_commodity:
                    return "近7日加工組合SKU排行"
                }
            }
        }
    }
    private enum CodingKeys: String, CodingKey {
        case reports = "detail"
    }
    let reports: [SKURankingReport]
    static let mock: Self = SKURankingReportList(reports: [SKURankingReport(image: "", id: "1", name: "【CONVERSE】1234567890 All Star CHUCK 70 男女 高筒 休閒鞋", saleQuantity: 99999999, saleAmount: 66666666.0), SKURankingReport(image: "", id: "2", name: "【SASAKI 棉質吸濕排汗功能運動休閒長衫-女-深葡", saleQuantity: 9999999, saleAmount: 6666666.0), SKURankingReport(image: "", id: "3", name: "SASAKI 棉質吸濕排汗功能運動休閒長衫-女-深葡", saleQuantity: 999999, saleAmount: 666666.0), SKURankingReport(image: "", id: "4", name: "SK-II 亮采化妝水160ml", saleQuantity: 99999, saleAmount: 66666.0), SKURankingReport(image: "", id: "5", name: "【Philips 飛利浦】耳掛式耳機SHS4700", saleQuantity: 9999, saleAmount: 6666.0)])
    
    // find the max value in reports?
    func getMaxValue(sortOrder: SKURankingReport.SKURankingReportSortOrder) -> Float {
        switch sortOrder {
        case .TOTAL_SALE_QUANTITY:
            return Float(reports.map{ $0.saleQuantity }.max() ?? 0)
        case .TOTAL_SALE_AMOUNT:
            return reports.map{ $0.saleAmount }.max() ?? 0.0
        }
    }
    
    func getProgress(_ index: Int, sortOrder: SKURankingReport.SKURankingReportSortOrder) -> Float {
        if reports.indices.contains(index) {
            switch sortOrder {
            case .TOTAL_SALE_QUANTITY:
                return Float(reports[index].saleQuantity ) / getMaxValue(sortOrder: sortOrder)
            case .TOTAL_SALE_AMOUNT:
                return reports[index].saleAmount / getMaxValue(sortOrder: sortOrder)
            }
        } else {
            return 0.0
        }
    }
}
// MARK: -- SaleRankingReport --
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
// MARK: -- SaleRankingReportList --
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
