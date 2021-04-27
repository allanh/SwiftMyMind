//
//  Purchase.swift
//  MyMind
//
//  Created by Barry Chen on 2021/4/27.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

enum PurchaseStatus: String, Codable {
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

enum SortOrder: String {
    case ascending = "ASC"
    case decending = "DESC"
}

struct PurchaseListQueryInfo {
    enum OrderReference: String {
        case purchaseNumber = "PURCHASE_NO"
        case status = "STATUS"
        case totalAmount = "TOTAL_AMOUNT"
        case createdDate = "CREATED_AT"
        case expectStorageDate = "EXPECT_STORAGE_DATE"
    }
    let partnerID: String
    var status: PurchaseStatus?
    var purchaseNumbers: [String] = []
    var vendorIDs: [String] = []
    var productNumbers: [String] = []
    var employeeIDs: [String] = []
    var expectStorageStartDate: Date?
    var expectStprageEndDate: Date?
    var firstCreatDate: Date?
    var lastCreatDate: Date?
    var pageNumber: Int = 1
    var itemsPerPage: Int = 20
    var sortOrder: SortOrder?
    var orderReference: OrderReference?

    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "partner_id", value: partnerID),
            URLQueryItem(name: "limit", value: String(itemsPerPage)),
            URLQueryItem(name: "current_page", value: String(pageNumber))
        ]
        if let status = self.status {
            let item = URLQueryItem(name: "status", value: status.rawValue)
            queryItems.append(item)
        }
        if purchaseNumbers.isEmpty == false {
            let value = purchaseNumbers.joined(separator: ",")
            let item = URLQueryItem(name: "purchase_no", value: value)
            queryItems.append(item)
        }
        if vendorIDs.isEmpty == false {
            let value = vendorIDs.joined(separator: ",")
            let item = URLQueryItem(name: "vendor_id", value: value)
            queryItems.append(item)
        }
        if productNumbers.isEmpty == false {
            let value = productNumbers.joined(separator: ",")
            let item = URLQueryItem(name: "product_no", value: value)
            queryItems.append(item)
        }
        if employeeIDs.isEmpty == false {
            let value = productNumbers.joined(separator: ",")
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
        if let expectStprageEndDate = expectStprageEndDate {
            let value = dateFormatter.string(from: expectStprageEndDate)
            let item = URLQueryItem(name: "expect_storage_end_date", value: value)
            queryItems.append(item)
        }
        if let firstCreatDate = firstCreatDate {
            let value = dateFormatter.string(from: firstCreatDate)
            let item = URLQueryItem(name: "create_started_at", value: value)
            queryItems.append(item)
        }
        if let lastCreatDate = lastCreatDate {
            let value = dateFormatter.string(from: lastCreatDate)
            let item = URLQueryItem(name: "create_ended_at", value: value)
            queryItems.append(item)
        }
        if let sortOrder = sortOrder {
            let item = URLQueryItem(name: "sort", value: sortOrder.rawValue)
            queryItems.append(item)
        }
        if let orderReference = orderReference {
            let item = URLQueryItem(name: "order_by", value: orderReference.rawValue)
            queryItems.append(item)
        }
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

struct PurchaseList {
    let items: [PurchaseBrief]
    let totalAmountOfItems: Int
    let totalAmountOfPages: Int
    let currentPageNumber: Int
    let itemsPerPage: Int

    enum CodingKeys: String, CodingKey {
        case items = "detail"
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
