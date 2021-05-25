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

final class AutoCompleteInfo: Decodable {
    let id: String?
    let number: String?
    let name: String?
    var isSelect: Bool = false

    init(id: String?, number: String?, name: String?, isSelect: Bool = false) {
        self.id = id
        self.number = number
        self.name = name
        self.isSelect = isSelect
    }

    required init(from decoder: Decoder) throws {
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

    private enum CodingKeys: String, CodingKey {
        case id, number = "no", name
    }
}

extension AutoCompleteInfo: Equatable {
    static func == (lhs: AutoCompleteInfo, rhs: AutoCompleteInfo) -> Bool {
        return lhs.id == rhs.id && lhs.number == rhs.number && lhs.name == rhs.name && lhs.isSelect == rhs.isSelect
    }

}
