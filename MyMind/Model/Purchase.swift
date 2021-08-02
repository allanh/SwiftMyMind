//
//  Purchase.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/27.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

enum PurchaseStatus: String, Codable, CaseIterable {
    case pending = "PENDING"
    case review = "REVIEW"
    case approved = "APPROVED"
    case purchasing = "PURCHASING"
    case putInStorage = "PUT_IN_STORAGE"
    case closed = "CLOSED"
    case unusual = "UNUSUAL"
    case rejected = "REVIEW_REJECT"
    case void = "VOID"
    case revoked = "REVOKED"
}

extension PurchaseStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .pending: return "待送審"
        case .review: return "審核中"
        case .approved: return "審核通過"
        case .purchasing: return "採購作業中"
        case .putInStorage: return "待結案"
        case .closed: return "已結案"
        case .unusual: return "異常入庫"
        case .rejected: return "退回"
        case .void: return "作廢"
        case .revoked: return ""
        }
    }
}

enum SortOrder: String {
    case ascending = "ASC"
    case decending = "DESC"
}

struct PurchaseListQueryInfo {
    enum OrderReference: String, CaseIterable, CustomStringConvertible {
        case createdDate = "CREATED_AT"
        case expectStorageDate = "EXPECT_STORAGE_DATE"
        case status = "STATUS"
        case totalAmount = "TOTAL_AMOUNT"
        case purchaseNumber = "PURCHASE_NO"

        var description: String {
            switch self {
            case .purchaseNumber: return "採購單編號"
            case .status: return "狀態"
            case .totalAmount: return "採購金額(未稅)"
            case .createdDate: return "填單日期"
            case .expectStorageDate: return "預計入庫日"
            }
        }
    }
    var status: PurchaseStatus?
    var purchaseNumbers: [AutoCompleteInfo] = []
    var vendorIDs: [AutoCompleteInfo] = []
    var productNumbers: [AutoCompleteInfo] = []
    var applicants: [AutoCompleteInfo] = []
    var expectStorageStartDate: Date?
    var expectStorageEndDate: Date?
    var createDateStart: Date?
    var createDateEnd: Date?
    var pageNumber: Int = 1
    var itemsPerPage: Int = 20
    var sortOrder: SortOrder? = .decending
    var orderReference: OrderReference = .createdDate

    static func defaultQuery() -> PurchaseListQueryInfo {
        return PurchaseListQueryInfo()
    }

    mutating func updateCurrentPageInfo(with purchaseList: PurchaseList) {
        self.pageNumber = purchaseList.currentPageNumber
        self.itemsPerPage = purchaseList.itemsPerPage
    }

    mutating func updatePageNumberForNextPage(with purchaseList: PurchaseList) -> Bool {
        guard purchaseList.totalAmountOfPages > purchaseList.currentPageNumber else { return false }
        self.pageNumber += 1
        return true
    }

    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(itemsPerPage)),
            URLQueryItem(name: "current_page", value: String(pageNumber))
        ]
        if let status = self.status {
            let item = URLQueryItem(name: "status", value: status.rawValue)
            queryItems.append(item)
        }
        if purchaseNumbers.isEmpty == false {
            let value = purchaseNumbers.compactMap { $0.number }.joined(separator: ",")
            let item = URLQueryItem(name: "purchase_no", value: value)
            queryItems.append(item)
        }
        if vendorIDs.isEmpty == false {
            let value = vendorIDs.compactMap { $0.id }.joined(separator: ",")
            let item = URLQueryItem(name: "vendor_id", value: value)
            queryItems.append(item)
        }
        if productNumbers.isEmpty == false {
            let value = productNumbers.compactMap { $0.number }.joined(separator: ",")
            let item = URLQueryItem(name: "product_no", value: value)
            queryItems.append(item)
        }
        if applicants.isEmpty == false {
            let value = applicants.compactMap { $0.id }.joined(separator: ",")
            let item = URLQueryItem(name: "employee_id", value: value)
            queryItems.append(item)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let expectStorageStartDate = expectStorageStartDate {
            let value = dateFormatter.string(from: expectStorageStartDate)
            let item = URLQueryItem(name: "expect_storage_start_date", value: value)
            queryItems.append(item)
        }
        if let expectStprageEndDate = expectStorageEndDate {
            let value = dateFormatter.string(from: expectStprageEndDate)
            let item = URLQueryItem(name: "expect_storage_end_date", value: value)
            queryItems.append(item)
        }
        if let createDateStart = createDateStart {
            let value = dateFormatter.string(from: createDateStart)
            let item = URLQueryItem(name: "create_started_at", value: value)
            queryItems.append(item)
        }
        if let createDateEnd = createDateEnd {
            let value = dateFormatter.string(from: createDateEnd)
            let item = URLQueryItem(name: "create_ended_at", value: value)
            queryItems.append(item)
        }
        if let sortOrder = sortOrder {
            let item = URLQueryItem(name: "sort", value: sortOrder.rawValue)
            queryItems.append(item)
        }
        let item = URLQueryItem(name: "order_by", value: orderReference.rawValue)
        queryItems.append(item)
        
        return queryItems
    }
}

enum AvaliableAction: String, Codable {
    case edit = "EDIT"
    case copy = "COPY"
    case view = "VIEW"
}

struct PurchaseBrief: Codable {
    let purchaseID: String
    let purchaseNumber: String
    let status: PurchaseStatus
    let totalAmount: String
    let vendorName: String
    let vendorNumber: String
    let createdDateString: String
    let expectStorageDateString: String
    let creator: String
    let availableActions: [AvaliableAction]

    private enum CodingKeys: String, CodingKey {
        case purchaseID = "purchase_id"
        case purchaseNumber = "purchase_no"
        case status = "status"
        case totalAmount = "total_amount"
        case vendorName = "alias_name"
        case vendorNumber = "vendor_no"
        case createdDateString = "created_at"
        case expectStorageDateString = "expect_storage_date"
        case creator = "created_by"
        case availableActions = "button"
    }
}

struct PurchaseList: MultiplePageList {
    struct StatusAmount: Codable {
        let pending: String
        let review: String
        let approved: String
        let purchasing: String
        let putInStorage: String
        let unusual: String
        let closed: String
        let rejected: String
        let void: String

        private enum CodingKeys: String, CodingKey {
            case pending, review, approved, purchasing, putInStorage = "put_in_storage", unusual, closed, rejected = "review_reject", void
        }
    }
    var items: [PurchaseBrief]
    let statusAmount: StatusAmount?
    let totalAmountOfItems: Int
    let totalAmountOfPages: Int
    var currentPageNumber: Int
    let itemsPerPage: Int

    mutating func updateWithNextPageList(purchaseList: PurchaseList) {
        self.items.append(contentsOf: purchaseList.items)
        self.currentPageNumber = purchaseList.currentPageNumber
    }

    enum CodingKeys: String, CodingKey {
        case items = "detail"
        case statusAmount = "status_amount"
        case totalAmountOfItems = "total"
        case totalAmountOfPages = "total_page"
        case currentPageNumber = "current_page"
        case itemsPerPage = "limit"
    }
}

extension PurchaseList: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([PurchaseBrief].self, forKey: .items)
        statusAmount = try? container.decode(StatusAmount.self, forKey: .statusAmount)
        var string = try? container.decode(String.self, forKey: .totalAmountOfItems)
        if let total = string {
            totalAmountOfItems = Int(total) ?? 0
        } else {
            if let value = try? container.decode(Int.self, forKey: .totalAmountOfItems) {
                totalAmountOfItems = value
            } else {
                totalAmountOfItems = 0
            }
        }
        string = try? container.decode(String.self, forKey: .totalAmountOfPages)
        if let pages = string {
            totalAmountOfPages = Int(pages) ?? 0
        } else {
            if let value = try? container.decode(Int.self, forKey: .totalAmountOfPages) {
                totalAmountOfPages = value
            } else {
                totalAmountOfPages = 0
            }
        }
        string = try? container.decode(String.self, forKey: .currentPageNumber)
        if let current = string {
            currentPageNumber = Int(current) ?? 0
        } else {
            if let value = try? container.decode(Int.self, forKey: .currentPageNumber) {
                currentPageNumber = value
            } else {
                currentPageNumber = 0
            }
        }
        string = try? container.decode(String.self, forKey: .itemsPerPage)
        if let perPage = string {
            itemsPerPage = Int(perPage) ?? 0
        } else {
            if let value = try? container.decode(Int.self, forKey: .itemsPerPage) {
                itemsPerPage = value
            } else {
                itemsPerPage = 0
            }
        }
    }
}

protocol MultiplePageList {
    var totalAmountOfItems: Int { get }
    var totalAmountOfPages: Int { get }
    var itemsPerPage: Int { get }
    var currentPageNumber: Int { get }
}
