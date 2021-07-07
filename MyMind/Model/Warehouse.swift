//
//  Warehouse.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct Warehouse: Codable {
    enum WarehouseType: String, Codable {
        case own = "OWN"
        case channel = "CHANNEL"
    }
    
    let id: Int
    let name, number: String
    let type: WarehouseType
    let channelWareroomID: String?
    let recipientInfo: [RecipientInfo]?

    enum CodingKeys: String, CodingKey {
        case name
        case type = "warehouse_type"
        case id = "warehouse_id"
        case number = "warehouse_no"
        case channelWareroomID = "channel_wareroom_id"
        case recipientInfo = "recipient_info"
    }
//    init(id: Int, name: String, number: String, type: WarehouseType, channelWareroomID: String?, recipientInfo: [RecipientInfo]?) {
//        self.id = id
//        self.name = name
//        self.number = number
//        self.type = type
//        self.channelWareroomID = channelWareroomID
//        self.recipientInfo = recipientInfo
//    }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        number = try container.decode(String.self, forKey: .number)
//        type = try container.decode(WarehouseType.self, forKey: .type)
//        channelWareroomID = try? container.decode(String.self, forKey: .channelWareroomID)
//        recipientInfo = try? container.decode([RecipientInfo].self, forKey: .recipientInfo)
//    }
}
