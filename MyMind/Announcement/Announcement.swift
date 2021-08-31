//
//  Bulltin.swift
//  MyMind
//
//  Created by Chijung Chan on 2021/8/20.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

enum AnnouncementType: String, Codable, CaseIterable {
    case system = "SYSTEM"
    case newFeature = "NEW_FEATURE"
    case optimization = "OPTIMIZATION"
    case news = "NEWS"
    case policy = "POLICY"
}
extension AnnouncementType: CustomStringConvertible {
    var description: String {
        switch self {
        case .system:
            return "系統"
        case .newFeature:
            return "新功能"
        case .optimization:
            return "優化"
        case .news:
            return "平台消息"
        case .policy:
            return "政策"
        }
    }
}
enum SortOrders: String {
    case ascending = "ASC"
    case decending = "DESC"
}
struct AnnouncementListQueryInfo {
    enum OrderReference: String, CaseIterable, CustomStringConvertible {
        case startedAt = "STARTED_AT"
        
        var description: String {
            switch self {
            case .startedAt: return "發布時間"
            }
        }
    }
    var title: [AutoCompleteInfo] = []
    var type: AnnouncementType?
    var startedAtFrom: Date?
    var startedAtTo: Date?
    var orderReference: OrderReference = .startedAt
    
    var isTop: Bool?
    var itemsPerPage: Int = 20
    var pageNumber: Int = 1
    var sortOrder: SortOrders? = .decending
    static func defaultQuery() -> AnnouncementListQueryInfo {
        return AnnouncementListQueryInfo()
    }
    
    mutating func updateCurrentPageInfo(with announcementList: AnnouncementList) {
        self.pageNumber = announcementList.currentPageNumber
        self.itemsPerPage = announcementList.itemsPerPage
    }
    
    mutating func updatePageNumberForNextPage(with announcementList: AnnouncementList) -> Bool {
        guard announcementList.totalAmountOfPages >
                announcementList.currentPageNumber else { return false }
        self.pageNumber += 1
        return true
    }
    var quertItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: String(itemsPerPage)),
            URLQueryItem(name: "current_page", value: String(pageNumber))
        ]
        if title.isEmpty == false {
            let value = title.compactMap { $0.name
            }.joined(separator: "")
            let item = URLQueryItem(name: "title", value: value)
            queryItems.append(item)
        }
        if let type = self.type {
            let item = URLQueryItem(name: "type", value: type.rawValue)
            queryItems.append(item)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let releaseTimeStart = startedAtFrom {
            let value = dateFormatter.string(from: releaseTimeStart)
            let item = URLQueryItem(name: "started_at_from", value: value)
            queryItems.append(item)
        }
        if let releaseTimeEnd = startedAtTo {
            let value = dateFormatter.string(from: releaseTimeEnd)
            let item = URLQueryItem(name: "started_at_to", value: value)
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
struct AnnouncementBrief: Codable {
    let title: String
    let type: String
    let startedAtString: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case type = "type"
        case startedAtString = "started_at"
    }
}
struct AnnouncementList: MultiplePageLists {
    struct TypeAmpunt: Codable {
        let system: String
        let newFeature: String
        let optimization: String
        let news: String
        let policy: String
    }
    
    var items: [AnnouncementBrief]
    var totalAmountOfItems: Int
    var totalAmountOfPages: Int
    var itemsPerPage: Int
    var currentPageNumber: Int
    
    mutating func updateWithNextPageList(announcementList: AnnouncementList)
    {
        self.items.append(contentsOf: announcementList.items)
        self.currentPageNumber = announcementList.currentPageNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case items = "detail"
        case totalAmountOfItems = "total"
        case totalAmountOfPages = "total_page"
        case currentPageNumber = "current_page"
        case itemsPerPage = "limit"
    }
    
}
extension AnnouncementList:  Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([AnnouncementBrief].self, forKey: .items)
        //statusAmount
        var string = try? container.decode(String.self, forKey:             .totalAmountOfItems)
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
protocol MultiplePageLists {
    var totalAmountOfItems: Int { get }
    var totalAmountOfPages: Int { get }
    var itemsPerPage: Int { get }
    var currentPageNumber: Int { get }
}
