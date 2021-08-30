//
//  Bulletin.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
struct Bulletin: Codable {
    enum BulletinType: String, Codable {
        case SYSTEM, NEW_FEATURE, OPTIMIZATION, NEWS, POLICY
    }
    enum BulletinLevel: String, Codable {
        case NORMAL, IMPORTANT
    }
    private enum CodingKeys: String, CodingKey {
        case title, type, importance
        case top = "is_top"
        case descriptions = "short_content"
        case start = "started_at"
        case id = "announcement_id"
    }
    let title: String
    let type: BulletinType
    let importance: BulletinLevel
    let top: Bool
    let descriptions: String
    let start: String
    let id: Int
}
struct BulletinList: Codable {
    let items: [Bulletin]
    private enum CodingKeys: String, CodingKey {
        case items = "detail"
    }
}
