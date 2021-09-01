//
//  Announcement.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
// MARK: -Importance
enum Importance: String, Codable {
    case NORMAL, IMPORTANT
}
enum AnnouncementType: String, Codable {
    case SYSTEM, NEW_FEATURE, OPTIMIZATION, NEWS, POLICY
}
// MARK: -Announcement
struct Announcement: Codable {
    private enum CodingKeys: String, CodingKey {
        case title, type, importance, content
        case top = "is_top"
        case started = "started_at"
        case readed = "read_at"
        case id = "announcement_id"
    }
    let title: String
    let type: AnnouncementType
    let importance: Importance
    let top: Bool
    let started: Date
    let readed: Date?
    let content: String?
    let id: Int
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        type = try container.decode(AnnouncementType.self, forKey: .type)
        importance = try container.decode(Importance.self, forKey: .importance)
        top = try container.decode(Bool.self, forKey: .top)
        let string = try container.decode(String.self, forKey: .started)
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        started = formatter.date(from: string) ?? .distantPast
        if let string = try? container.decode(String.self, forKey: .readed) {
            readed = formatter.date(from: string)
        } else {
            readed = nil
        }
        id = try container.decode(Int.self, forKey: .id)
        content = try? container.decode(String.self, forKey: .content)
    }
}
// MARK: -AnnouncementList
struct AnnouncementList: MultiplePageList, Codable {
    private enum CodingKeys: String, CodingKey {
        case items = "detail"
        case totalAmountOfItems = "total"
        case totalAmountOfPages = "total_page"
        case currentPageNumber = "current_page"
        case itemsPerPage = "limit"
    }
    var items: [Announcement]
    let totalAmountOfItems: Int
    let totalAmountOfPages: Int
    var currentPageNumber: Int
    let itemsPerPage: Int
    mutating func updateWithNextPageList(announcementList: AnnouncementList) {
        self.items.append(contentsOf: announcementList.items)
        self.currentPageNumber = announcementList.currentPageNumber
    }
}
