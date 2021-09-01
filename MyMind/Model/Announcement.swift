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
        case title, type, importance
        case top = "is_top"
        case started = "started_at"
        case readed = "read_at"
        case id = "announcement_id"
    }
    let title: String
    let type: AnnouncementType
    let importance: Importance
    let top: Bool
    let started: String
    let readed: String?
    let id: Int
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
