//
//  Bulletin.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
// MARK: -Bulletin
struct Bulletin: Codable {
    private enum CodingKeys: String, CodingKey {
        case title, type, importance
        case top = "is_current_top"
        case descriptions = "short_content"
        case start = "started_at"
        case id = "announcement_id"
    }
    let title: String
    let type: AnnouncementType
    let importance: Importance
    let top: Bool
    let descriptions: String
    let start: Date
    let id: Int
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        type = try container.decode(AnnouncementType.self, forKey: .type)
        importance = try container.decode(Importance.self, forKey: .importance)
        top = try container.decode(Bool.self, forKey: .top)
        let string = try container.decode(String.self, forKey: .start)
        let formatter = DateFormatter {
            $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        start = formatter.date(from: string) ?? .distantPast
        descriptions = try container.decode(String.self, forKey: .descriptions)
        id = try container.decode(Int.self, forKey: .id)
    }
}
// MARK: -BulletinList
struct BulletinList: Codable {
    let items: [Bulletin]
    private enum CodingKeys: String, CodingKey {
        case items = "detail"
    }
}
