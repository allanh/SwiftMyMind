//
//  ChangePasswordInfo.swift
//  MyMind
//
//  Created by Shih Allan on 2021/11/17.
//  Copyright © 2021 United Digital Intelligence. All rights reserved.
//

import Foundation
struct ChangePasswordInfoValidateStatus: OptionSet {
    let rawValue: Int
    static let valid = ChangePasswordInfoValidateStatus(rawValue: 1 << 0)
    static let oldPasswordError = ChangePasswordInfoValidateStatus(rawValue: 1 << 1)
    static let passwordError = ChangePasswordInfoValidateStatus(rawValue: 1 << 2)
    static let confirmPasswordError = ChangePasswordInfoValidateStatus(rawValue: 1 << 3)
}

struct ChangePasswordInfo {
    private enum CodingKeys: String, CodingKey {
        case old_password, password
    }

    var oldPassword: String
    var password: String

    static func empty() -> ChangePasswordInfo {
        let info = ChangePasswordInfo(oldPassword: "", password: "")
        return info
    }
    
    func validate() -> AccountValidateStatus {
        var status: AccountValidateStatus = .valid
        if oldPassword.count < 1 || oldPassword.count > 20 {
            status.update(with: .nameError)
        }
        if SignInValidatoinService().validateEmail(email) != .valid {
            status.update(with: .emailError)
        }
        return status
    }
}

extension ChangePasswordInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(oldPassword, forKey: .old_password)
        try container.encode(password, forKey: .password)
    }
}
