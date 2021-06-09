//
//  Reviewer.swift
//  MyMind
//
//  Created by Barry Chen on 2021/6/8.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct Reviewer: Codable, Equatable {
    let id: String
    let account: String

    enum CodingKeys: String, CodingKey {
        case id = "employee_id"
        case account
    }
}
