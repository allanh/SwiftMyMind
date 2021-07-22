//
//  ResendOTPInfo.swift
//  MyMind
//
//  Created by Nelson Chan on 2021/7/19.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
struct ResendOTPInfo {
    private enum CodingKeys: String, CodingKey {
        case id, account, password
    }

    var storeID: String
    var account: String
    var password: String

    static func empty() -> ResendOTPInfo {
        let info = ResendOTPInfo(storeID: "", account: "", password: "")
        return info
    }
}

extension ResendOTPInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storeID, forKey: .id)
        try container.encode(account, forKey: .account)
        try container.encode(password, forKey: .password)
    }
}
