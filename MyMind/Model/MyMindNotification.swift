//
//  MyMindNotification.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/9/1.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
// MARK: -MyMindNotification
struct MyMindNotification: Codable {
    enum NotificationType: String, Codable {
        case ANNOUNCEMENT
    }
    private enum CodingKeys: String, CodingKey {
        case title, type, importance
        case subTitle = "sub_title"
        case top = "is_top"
        case started = "started_at"
        case readed = "read_at"
        case id = "notification_id"
    }
    let title: String
    let subTitle: String
    let type: NotificationType
    let importance: Importance
    let top: Bool
    let started: String
    let readed: String?
    let id: Int
}
// MARK: -MyMindNotificationList
struct MyMindNotificationList: Codable {
    let items: [MyMindNotification]
    let unreaded: Int
    private enum CodingKeys: String, CodingKey {
        case items = "detail"
        case unreaded = "unread_count"
    }
}
