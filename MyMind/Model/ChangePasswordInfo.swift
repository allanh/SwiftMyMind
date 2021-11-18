//
//  ChangePasswordInfo.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/17.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation

struct ChangePasswordInfo {
    private enum CodingKeys: String, CodingKey {
        case old_password, password
    }

    var oldPassword: String
    var password: String
    var confirmPassword: String
    var jsonRepresentation: [String: Any] {
        get {
            return ["old_password": oldPassword, "password": password]
        }
    }
    
    static func empty() -> ChangePasswordInfo {
        let info = ChangePasswordInfo(oldPassword: "", password: "", confirmPassword: "")
        return info
    }
}

extension ChangePasswordInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(oldPassword, forKey: .old_password)
        try container.encode(password, forKey: .password)
    }
}
