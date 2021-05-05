//
//  AutoCompleteInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct AutoCompleteList: Codable {
    let item: [AutoCompleteInfo]

    private enum CodingKeys: String, CodingKey {
        case item = "detail"
    }
}

struct AutoCompleteInfo: Codable {
    let id: String?
    let number: String?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case id, number = "no", name
    }
}
