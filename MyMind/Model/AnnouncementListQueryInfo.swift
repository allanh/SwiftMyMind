//
//  AnnouncementListQueryInfo.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
// MARK: -AnnouncementListQueryInfo
class AnnouncementListQueryInfo {
    enum AnnouncementOrder: String, Codable, CaseIterable, CustomStringConvertible {
        case STARTED_AT
        var description: String {
            get {
                switch self {
                case .STARTED_AT: return "發布時間"
                }
            }
        }
    }
    var title: String? = nil
    var type: AnnouncementType? = nil
    var top: Bool? = nil
    var start: Date? = nil
    var end: Date? = nil
    var order: AnnouncementOrder = .STARTED_AT
    var sort: SortOrder? = .decending
    var current: Int? = nil
    var limit: Int? = nil
    var queryItems: [URLQueryItem] {
        get {
            var items: [URLQueryItem] = []
            if let title = title, !title.isEmpty {
                items.append(URLQueryItem(name: "title", value: title))
            }
            if let type = type {
                items.append(URLQueryItem(name: "type", value: type.rawValue))
            }
            if let top = top {
                items.append(URLQueryItem(name: "is_current_top", value: top ? "true" : "false"))
            }
            let formatter = DateFormatter {
                $0.dateFormat = "yyyy-MM-dd"
            }
            if let start = start {
                items.append(URLQueryItem(name: "started_at_from", value: formatter.string(from: start)+" 00:00:00"))
            }
            if let end = end {
                items.append(URLQueryItem(name: "started_at_to", value: formatter.string(from: end)+" 23:59:59"))
            }
            items.append(URLQueryItem(name: "order_by", value: order.rawValue))
            if let sort = sort {
                items.append(URLQueryItem(name: "sort", value: sort.rawValue))
            }
            if let current = current {
                items.append(URLQueryItem(name: "current_page", value: String(current)))
            }
            if let limit = limit {
                items.append(URLQueryItem(name: "limit", value: String(limit)))
            }
            return items
        }
    }
    var isModified: Bool {
        get {
            return type != nil || title != nil || start != nil || end != nil
        }
    }
    static func defaultQuery() -> AnnouncementListQueryInfo {
        return AnnouncementListQueryInfo()
    }

}
extension AnnouncementListQueryInfo: Equatable {
    static func == (lhs: AnnouncementListQueryInfo, rhs: AnnouncementListQueryInfo) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end && lhs.title == rhs.title && lhs.type == rhs.type
    }
}
