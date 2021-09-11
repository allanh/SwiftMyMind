//
//  Registration.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/8/30.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
struct Registration: Codable {
    private enum CodingKeys: String, CodingKey {
        case id = "device_id", isCreated = "is_created"
    }
    let id: String
    let isCreated: Bool
}
