//
//  RecipientInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/18.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct RecipientInfo: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case phone
        case address
        case warehouseIndex = "warehouse_index"
    }

    let name, phone: String?
    let address: Address
    let warehouseIndex: Int
}

struct Address: Codable {
    let county, district, zipcode, address: String?

    var fullAddressString: String {
        "\(zipcode ?? "") \(county ?? "")\(district ?? "")\(address ?? "")"
    }
}
