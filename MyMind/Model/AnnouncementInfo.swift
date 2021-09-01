//
//  AnnouncementInfo.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
// MARK: -AnnouncementInfo
class AnnouncementInfo {
    enum AnnouncementOrder: String, Codable {
        case STARTED_AT
    }
    var title: String? = nil
    var type: AnnouncementType? = nil
    var top: Bool? = nil
    var start: Date? = nil
    var end: Date? = nil
    var order: AnnouncementOrder? = nil
    var sort: SortOrder? = nil
    var current: Int? = nil
    var limit: Int? = nil
    var queryItems: [URLQueryItem] {
        get {
            var items: [URLQueryItem] = []
            if let title = title {
                items.append(URLQueryItem(name: "title", value: title))
            }
            if let type = type {
                items.append(URLQueryItem(name: "type", value: type.rawValue))
            }
            if let top = top {
                items.append(URLQueryItem(name: "is_top", value: top ? "true" : "false"))
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
            if let order = order {
                items.append(URLQueryItem(name: "order_by", value: order.rawValue))
            }
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
}
