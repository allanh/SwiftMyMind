//
//  AutoCompleteInfo.swift
//  MyMind
//
//  Created by Barry Chen on 2021/5/5.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct AutoCompleteList: Decodable {
    let item: [AutoCompleteInfo]

    private enum CodingKeys: String, CodingKey {
        case item = "detail"
    }
}

struct AutoCompleteInfo: Equatable {
    let id: String?
    let number: String?
    let name: String?

    private enum CodingKeys: String, CodingKey {
        case id, number = "no", name
    }
}
extension AutoCompleteInfo: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decodeIfPresent(String.self, forKey: .number)
        if let idNumber = try? container.decodeIfPresent(Int.self, forKey: .id) {
            id = String(idNumber)
        } else if let idString = try? container.decodeIfPresent(String.self, forKey: .id) {
            id = idString
        } else {
            id = nil
        }
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}
