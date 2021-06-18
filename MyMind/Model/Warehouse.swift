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

    let name, id, number: String
    let type: WarehouseType
    let channelWareroomID: String
    let recipientInfo: RecipientInfo?

    enum CodingKeys: String, CodingKey {
        case name
        case type = "warehouse_type"
        case id = "warehouse_id"
        case number = "warehouse_no"
        case channelWareroomID = "channel_wareroom_id"
        case recipientInfo = "recipient_info"
    }
}
