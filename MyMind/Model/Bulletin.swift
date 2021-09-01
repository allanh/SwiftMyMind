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
        case top = "is_top"
        case descriptions = "short_content"
        case start = "started_at"
        case id = "announcement_id"
    }
    let title: String
    let type: AnnouncementType
    let importance: Importance
    let top: Bool
    let descriptions: String
    let start: String
    let id: Int
}
// MARK: -BulletinList
struct BulletinList: Codable {
    let items: [Bulletin]
    private enum CodingKeys: String, CodingKey {
        case items = "detail"
    }
}
