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
        case top = "is_current_top"
        case started = "started_at"
        case readed = "read_at"
        case id = "notification_id"
    }
    let title: String
    let subTitle: String
    let type: NotificationType
    let importance: Importance
    let top: Bool
    let started: Date
    let readed: Date?
    let id: Int
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subTitle = try container.decode(String.self, forKey: .subTitle)
        type = try container.decode(NotificationType.self, forKey: .type)
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
    }
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
